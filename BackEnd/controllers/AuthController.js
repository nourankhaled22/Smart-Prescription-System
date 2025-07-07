const asyncWrapper = require("../middleware/asyncWrapper");
const httpStatusText = require('../utils/httpStatusText');
const appError = require('../utils/appError');
const bcrypt = require('bcryptjs');
const generateJWT = require("../utils/generateJWT");
const Patient = require("../models/Patient");
const Doctor = require("../models/Doctor");
const Admin = require("../models/Admin");   
const checkPhoneNumber = require('../utils/checkPhoneNumber')
const checkNationalId = require('../utils/checkNationalId')
const cloudinary = require('../config/cloudinaryConfig');
const jwt = require('jsonwebtoken')
const checkStrongPassword = require('../utils/checkStrongPassword')
const generateOtp = require('../utils/generateOtp');
const sendOtp = require('../utils/whatsAppSender');
const { redisClient, connectRedis } = require('../utils/redisClient');

const patientRegister = asyncWrapper(async (req, res, next) => {
    const { firstName, lastName, phoneNumber, password, dateOfBirth, nationalId, address } = req.body;
    if(!firstName || !lastName || !phoneNumber || !password || !dateOfBirth || !nationalId) {
        const error = appError.create('missing fields data', 400, httpStatusText.FAIL)
        return next(error);
    }

    if (!checkPhoneNumber(phoneNumber)) {
        const error = appError.create('invalid phone number', 400, httpStatusText.FAIL)
        return next(error);
    }

    if (!checkNationalId(nationalId)) {
        const error = appError.create('invalid National ID', 400, httpStatusText.FAIL)
        return next(error);
    }

    if (!checkStrongPassword(password)) {
        const error = appError.create('password is not strong enough, password must be at least 6 characters, pasword must contain at least one uppercase letter, one lowercase letter, one number', 400, httpStatusText.FAIL)
        return next(error);
    }

    const oldPatient1 = await Patient.findOne({ phoneNumber: phoneNumber});
    const oldPatient2 = await Patient.findOne({ nationalId: nationalId});
    if(oldPatient2) {
        const error = appError.create('national id already exists', 400, httpStatusText.FAIL)
        return next(error);
    }
    // check if patient registered as doctor with same phone number
    const existAsDoctor = await Doctor.findOne({ phoneNumber: phoneNumber });
    const existAsAdmin = await Admin.findOne({ phoneNumber: phoneNumber });
    if (oldPatient1 || existAsDoctor || existAsAdmin) {
        const error = appError.create('phone number already exist', 400, httpStatusText.FAIL)
        return next(error);
    }
    
    // password hashing
    const hashedPassword = await bcrypt.hash(password, 10);
    const newPatient = new Patient({
        firstName,
        lastName,
        phoneNumber,
        password: hashedPassword,
        dateOfBirth,
        nationalId,
        address,
    })
    // generate JWT token 
    const token = await generateJWT({phoneNumber: newPatient.phoneNumber, id: newPatient._id, nationalId: newPatient.nationalId,role: "patient"});
    newPatient.token = token;
    try {
        const otp = generateOtp();
        await sendOtp(`2${phoneNumber}`, `Welcome to Smart Prescription System Application, Your verification code is: ${otp}`);
        console.log(otp)
        // save otp , newpatient in redis
        // deleted automatichally from redis after 24 hours
        await connectRedis();
        await redisClient.set(phoneNumber, JSON.stringify({ otp:otp, user: newPatient, expiresAt: Date.now() + 5 * 60 * 1000,}), {'EX': 24*60*60}); // expire in 5 minutes
        res.status(201).json({ status: httpStatusText.SUCCESS, data: { otp } });
    } catch (error) {
        const otpError = appError.create('Error sending OTP ------', 500, httpStatusText.FAIL);
        return next(otpError);
    }
})


const doctorRegister = asyncWrapper(async (req, res, next) => {
    if (!req.file) {
        const error = appError.create('licence is required', 400, httpStatusText.FAIL)
        return next(error);
    }
    const { firstName, lastName, phoneNumber, password, dateOfBirth, specialization, clinicAddress} = req.body;
    
    if(!firstName || !lastName || !phoneNumber || !password || !dateOfBirth || !specialization || !clinicAddress) {
        await cloudinary.uploader.destroy(req.file.filename);
        const error = appError.create('missing fields data', 400, httpStatusText.FAIL)
        return next(error);
    }

    if (!checkPhoneNumber(phoneNumber)) {
        await cloudinary.uploader.destroy(req.file.filename);
        const error = appError.create('invalid phone number', 400, httpStatusText.FAIL)
        return next(error);
    }

    if (!checkStrongPassword(password)) {
        await cloudinary.uploader.destroy(req.file.filename);
        const error = appError.create('password is not strong enough, password must be at least 6 characters, pasword must contain at least one uppercase letter, one lowercase letter, one number', 400, httpStatusText.FAIL)
        return next(error);
    }

    const oldDoctor = await Doctor.findOne({ phoneNumber: phoneNumber});
    const existAsPatient = await Patient.findOne({ phoneNumber: phoneNumber });
    const existAsAdmin = await Admin.findOne({ phoneNumber: phoneNumber });
    if(oldDoctor || existAsPatient || existAsAdmin) {
        await cloudinary.uploader.destroy(req.file.filename);
        const error = appError.create('phone number already exists', 400, httpStatusText.FAIL)
        return next(error);
    }

    // password hashing
    const hashedPassword = await bcrypt.hash(password, 10);
    const newDoctor = new Doctor({
        firstName,
        lastName,
        phoneNumber,
        password: hashedPassword,
        dateOfBirth,
        specialization,
        clinicAddress,
        licenceUrl: req.file.path,
        licencePublicId: req.file.filename
    })
    
    // generate JWT token 
    const token = await generateJWT({phoneNumber: newDoctor.phoneNumber, id: newDoctor._id, role: "doctor"});
    newDoctor.token = token;
    try {
        const otp = generateOtp();
        await sendOtp(`2${phoneNumber}`, `Welcome to Smart Prescription System Application, Your verification code is: ${otp}`);
        console.log(otp)
        // save otp , newpatient in redis
        // deleted automatichally from redis after 24 hours
        await connectRedis();
        await redisClient.set(phoneNumber, JSON.stringify({ otp:otp, user: newDoctor, expiresAt: Date.now() + 5 * 60 * 1000 }), {'EX': 24*60*60}); // expire in 5 minutes
        res.status(201).json({ status: httpStatusText.SUCCESS, data: { otp } });
    } catch (error) {
        const otpError = appError.create('Error sending OTP', 500, httpStatusText.FAIL);
        return next(otpError);
    }
})

const login = asyncWrapper(async (req, res, next) => {
    const {phoneNumber, password} = req.body;
    if(!phoneNumber || !password) {
        const error = appError.create('phone number and password are required', 400, httpStatusText.FAIL)
        return next(error);
    }
    const patient = await Patient.findOne({phoneNumber: phoneNumber});
    const doctor = await Doctor.findOne({phoneNumber: phoneNumber});
    const admin = await Admin.findOne({phoneNumber: phoneNumber});

    if(!patient && !doctor && !admin) {
        const error = appError.create('phone number not exist', 400, httpStatusText.FAIL)
        return next(error);
    }
    if (patient) {
        if (patient.status !== "active") {
            const error = appError.create('account is not active', 400, httpStatusText.FAIL)
            return next(error);
        }
        const matchedPassword = await bcrypt.compare(password, patient.password);
        if(matchedPassword) {
            
            const token = await generateJWT({phoneNumber: patient.phoneNumber, id: patient._id, nationalId: patient.nationalId, role: patient.role});
            patient.token = token;
            const patientObject = patient.toObject();
            delete patientObject.__v;
            delete patientObject.password;
            delete patientObject.createdAt,
            delete patientObject.updatedAt;
            res.status(200).json({ status: httpStatusText.SUCCESS, data: { user: patientObject } });    
        }
    }
    if (doctor) {
        if (doctor.status !== "active") {
            const error = appError.create('account is not active', 400, httpStatusText.FAIL)
            return next(error);
        }
        const matchedPassword = await bcrypt.compare(password, doctor.password);
        if (matchedPassword) {
            const token = await generateJWT({phoneNumber: doctor.phoneNumber, id: doctor._id, role: doctor.role});
            doctor.token = token;
            const doctorObject = doctor.toObject();
            delete doctorObject.__v;
            delete doctorObject.password;
            delete doctorObject.createdAt;
            delete doctorObject.updatedAt;
            delete doctorObject.licencePublicId;
            res.status(200).json({ status: httpStatusText.SUCCESS, data: { user: doctorObject } });
        }
    }
    if (admin) {
        const matchedPassword = await bcrypt.compare(password, admin.password);
        if (matchedPassword) {
            const token = await generateJWT({phoneNumber: admin.phoneNumber, id: admin._id, role: admin.role});
            admin.token = token;
            const adminObject = admin.toObject();
            delete adminObject.__v;
            delete adminObject.password;
            delete adminObject.createdAt;
            delete adminObject.updatedAt;
            res.status(200).json({ status: httpStatusText.SUCCESS, data: { user: adminObject } });
        }
    }
    const error = appError.create('incorrect password', 400, httpStatusText.FAIL)
    return next(error);
})


const verifyOtp = asyncWrapper(async (req, res, next) => {
    const { phoneNumber, enteredOtp } = req.body;
    await connectRedis();
    const data = await redisClient.get(phoneNumber);

    if (!data) {
        const error = appError.create('OTP expired or not found', 400, httpStatusText.FAIL)
        return next(error);
    }

    const { otp, expiresAt, user } = JSON.parse(data);
    // console.log("otp ----->>> ", otp)
    // console.log("user  --->> ", user)
    if (Date.now() > expiresAt) {
        const error = appError.create('OTP has expired', 400, httpStatusText.FAIL)
        return next(error);
    }

    if (otp !== enteredOtp) {
        const error = appError.create('incorrect OTP', 400, httpStatusText.FAIL)
        return next(error);
    }

    // Success: OTP is correct and valid
    if (user.role == "patient") {
        const patient = new Patient(user);
        await patient.save();
    }
    else {
        const doctor = new Doctor(user);
        await doctor.save();
    }

    await redisClient.del(user.phoneNumber);
    delete user.__v;
    delete user.password;
    delete user.createdAt;
    delete user.updatedAt;

    res.status(201).json({ status: httpStatusText.SUCCESS, data: { user } });
});


const resendOtp = asyncWrapper(async (req, res, next) => {
    const {phoneNumber} = req.body;
    try {
        await connectRedis();
        const data = await redisClient.get(phoneNumber);
        if (data) {
            const { user } = JSON.parse(data);
            // console.log(user)
            const otp = generateOtp();
            await sendOtp(`2${phoneNumber}`, `Welcome to Smart Prescription System Application, Your verification code is: ${otp}`);
            console.log(otp)
            // deleted automatichally from redis after 24 hours
            await redisClient.set(phoneNumber, JSON.stringify({ otp:otp, user: user, expiresAt: Date.now() + 5 * 60 * 1000 }), {'EX': 24*60*60}); // expire in 5 minutes
            res.status(201).json({ status: httpStatusText.SUCCESS, data: {otp }});
        }
        else {
            const otpError = appError.create('register first', 400, httpStatusText.FAIL);
            return next(otpError);
        }
    } catch (error) {
        console.log(error)
        const otpError = appError.create('----- Error sending OTP ------', 500, httpStatusText.FAIL);
        return next(otpError);
    }  
}) 

const resetForForgetPassword = asyncWrapper(async (req, res, next) => {
    const {phoneNumber} = req.params;
    const {newPassword } = req.body;

    await connectRedis();
    const data = await redisClient.get(phoneNumber);
    if (!data) {
        const error = appError.create('select forget password', 400, httpStatusText.FAIL)
        return next(error);
    }
    const { flag } = JSON.parse(data);
    if (!flag) {
        const error = appError.create('verify otp first', 400, httpStatusText.FAIL)
        return next(error);
    }
    const patient = await Patient.findOne({phoneNumber: phoneNumber});
    const doctor = await Doctor.findOne({phoneNumber: phoneNumber});
    const admin = await Admin.findOne({phoneNumber: phoneNumber});
    if(!patient && !doctor && !admin) {
        const error = appError.create('phone number not exist', 400, httpStatusText.FAIL)
        return next(error);
    }

    if (!checkStrongPassword(newPassword)) {
        const error = appError.create('new password is not strong enough, password must be at least 6 characters, pasword must contain at least one uppercase letter, one lowercase letter, one number', 400, httpStatusText.FAIL)
        return next(error);
    }

    const hashedPassword = await bcrypt.hash(newPassword, 10);
    if (patient) {
        const updatedPatient = await Patient.findOneAndUpdate(
            {phoneNumber}, 
            {$set: {password: hashedPassword}}, 
            { new: true }
        ).select('-__v -createdAt -updatedAt -password');
        await redisClient.del(phoneNumber);
        return res.status(201).json({ status: httpStatusText.SUCCESS, data: null });
    }
    if (doctor) {
        const updatedPatient = await Doctor.findOneAndUpdate(
            {phoneNumber}, 
            {$set: {password: hashedPassword}}, 
            { new: true }
        ).select('-__v -createdAt -updatedAt -password -licenceUrl -licencePublicId');
        await redisClient.del(phoneNumber);
        return res.status(201).json({ status: httpStatusText.SUCCESS, data: null });
    }
    if (admin) {
        const updatedPatient = await Admin.findOneAndUpdate(
            {phoneNumber}, 
            {$set: {password: hashedPassword}}, 
            { new: true }
        ).select('-__v -createdAt -updatedAt -password');
        await redisClient.del(phoneNumber);
        return res.status(201).json({ status: httpStatusText.SUCCESS, data: null });
    }
});

const forgetPassword = asyncWrapper(async (req, res, next) => {
    const {phoneNumber} = req.body;
    const patient = await Patient.findOne({phoneNumber: phoneNumber});
    const doctor = await Doctor.findOne({phoneNumber: phoneNumber});
    const admin = await Admin.findOne({phoneNumber: phoneNumber});
    if (!patient && !doctor && !admin) {
        const error = appError.create('phone number not exist', 400, httpStatusText.FAIL)
        return next(error);
    }
    const otp = generateOtp();
    await sendOtp(`2${phoneNumber}`, `Welcome to Smart Prescription System Application, Your verification code is: ${otp}`);
    console.log(otp)
    await connectRedis();
    await redisClient.set(phoneNumber, JSON.stringify({ otp:otp, expiresAt: Date.now() + 5 * 60 * 1000, flag: false }), {'EX': 24*60*60}); // expire in 5 minutes
    res.status(200).json({ status: httpStatusText.SUCCESS, data: {otp}});
})

const verifyOtpForForgetPassword = asyncWrapper(async (req, res, next) => {
    const {phoneNumber} = req.params;
    const {enteredOtp} = req.body;
    await connectRedis();
    const data = await redisClient.get(phoneNumber);
    if (!data) {
        const error = appError.create('OTP expired or not found', 400, httpStatusText.FAIL)
        return next(error);
    }
    const {otp, expiresAt } = JSON.parse(data);
    if (Date.now() > expiresAt) {
        const error = appError.create('OTP has expired', 400, httpStatusText.FAIL)
        return next(error);
    }
    if (otp !== enteredOtp) {
        const error = appError.create('incorrect OTP', 400, httpStatusText.FAIL)
        return next(error);
    }
    // correct otp
    // await redisClient.del(phoneNumber);
    await redisClient.set(phoneNumber, JSON.stringify({ otp:otp, expiresAt: Date.now() + 5 * 60 * 1000, flag: true }), {'EX': 24*60*60}); // expire in 5 minutes
    res.status(200).json({ status: httpStatusText.SUCCESS, data: null});
})

const getProfile = asyncWrapper(async (req, res, next) => {
    const role = req.currentUser.role;
    const id = req.currentUser.id;
    if (role === "patient") {
        const patient = await Patient.findById(id, {'__v': false, 'createdAt': false, 'updatedAt': false, 'password': false, 'chats': false});
        return res.status(201).json({ status: httpStatusText.SUCCESS, data: { user: patient } });
    }
    if (role === "doctor") {
        const doctor = await Doctor.findById(id, {'__v': false, 'createdAt': false, 'updatedAt': false, 'password': false, 'licencePublicId': false});
        return res.status(201).json({ status: httpStatusText.SUCCESS, data: { user: doctor } });
    }
    if (role === "admin") {
        const admin = await Admin.findById(id, {'__v': false, 'createdAt': false, 'updatedAt': false, 'password': false});
        return res.status(201).json({ status: httpStatusText.SUCCESS, data: { user: admin } });
    }
})

const updateProfile = asyncWrapper(async (req, res, next) => {
    const role = req.currentUser.role;
    const id = req.currentUser.id;
    console.log (role, id)
    // Prevent updating phoneNumber
    if ('phoneNumber' in req.body) {
        delete req.body.phoneNumber;
    }
    if ('status' in req.body) {
        delete req.body.status;
    }
    if ('password' in req.body) {
        delete req.body.password;
    }
    
    if (role === "patient") {
        if ('nationalId' in req.body) {
            delete req.body.nationalId;
        }
        if ('chats' in req.body) {
            delete req.body.chats;
        }
        const updatedPatient = await Patient.findOneAndUpdate(
            {_id: id}, 
            {$set: req.body}, 
            { new: true , runValidators: true} // Return the updated document
        ).select('-__v -createdAt -updatedAt -password -chats');
        return res.status(200).json({ status: httpStatusText.SUCCESS, data: { user: updatedPatient } });
    }
    if (role === "doctor") {
        if ('licenceFileName' in req.body) {
            delete req.body.licenceFileName;
        }
        const updatedDoctor = await Doctor.findOneAndUpdate(
            {_id: id}, 
            {$set: req.body}, 
            { new: true, runValidators: true } // Return the updated document
        ).select('-__v -createdAt -updatedAt -password -licencePublicId');
        return res.status(200).json({ status: httpStatusText.SUCCESS, data: { user: updatedDoctor } });
    }
    if (role === "admin") {
        const updatedAdmin = await Admin.findOneAndUpdate(
            {_id: id}, 
            {$set: req.body}, 
            { new: true, runValidators: true } // Return the updated document
        ).select('-__v -createdAt -updatedAt -password');
        return res.status(200).json({ status: httpStatusText.SUCCESS, data: { user: updatedAdmin } });
    }
})

const resetPassword = asyncWrapper(async (req, res, next) => {
    const id = req.currentUser.id;
    const role = req.currentUser.role;
    const {oldPassword, newPassword} = req.body;
    if (!oldPassword || !newPassword) {
        const error = appError.create('old password and new password are required', 400, httpStatusText.FAIL)
        return next(error);
    }
    if (!checkStrongPassword(newPassword)) {
        const error = appError.create('new password is not strong enough, password must be at least 6 characters, pasword must contain at least one uppercase letter, one lowercase letter, one number', 400, httpStatusText.FAIL)
        return next(error);
    }
    if (role === "patient") {
        const patient = await Patient.findById(id);
        const isPasswordCorrect = await bcrypt.compare(oldPassword, patient.password);
        if (!isPasswordCorrect) {
            const error = appError.create('incorrect old password', 400, httpStatusText.FAIL)
            return next(error);
        }
        const hashedPassword = await bcrypt.hash(newPassword, 10);
        const updatedPatient = await Patient.findOneAndUpdate(
        {_id: id}, 
        {$set: {password: hashedPassword}}, 
        { new: true }
        ).select('-__v -createdAt -updatedAt -password -chats');
        return res.status(201).json({ status: httpStatusText.SUCCESS, data: { patient: updatedPatient } });
    }
    if (role === "doctor") {
        const doctor = await Doctor.findById(id);
        const isPasswordCorrect = await bcrypt.compare(oldPassword, doctor.password);
        if (!isPasswordCorrect) {
            const error = appError.create('incorrect old password', 400, httpStatusText.FAIL)
            return next(error);
        }
        const hashedPassword = await bcrypt.hash(newPassword, 10);
        const updatedDoctor = await Doctor.findOneAndUpdate(
        {_id: id}, 
        {$set: {password: hashedPassword}}, 
        { new: true }
        ).select('-__v -createdAt -updatedAt -password');
        return res.status(201).json({ status: httpStatusText.SUCCESS, data: { doctor: updatedDoctor } });
    }
    if (role === "admin") {
        const admin = await Admin.findById(id);
        const isPasswordCorrect = await bcrypt.compare(oldPassword, admin.password);
        if (!isPasswordCorrect) {
            const error = appError.create('incorrect old password', 400, httpStatusText.FAIL)
            return next(error);
        }
        const hashedPassword = await bcrypt.hash(newPassword, 10);
        const updatedAdmin = await Admin.findOneAndUpdate(
        {_id: id}, 
        {$set: {password: hashedPassword}}, 
        { new: true }
        ).select('-__v -createdAt -updatedAt -password');
        return res.status(201).json({ status: httpStatusText.SUCCESS, data: { admin: updatedAdmin } });
    }
})

const isValidSessionToken = asyncWrapper(async (req, res, next) => { 
    const token = req.headers['SessionToken'] || req.headers['sessiontoken'];
    if(!token) {
        const error = appError.create('session token is required', 401, httpStatusText.ERROR)
        return next(error);
    }

    const Token = token.split(' ')[1];
    try {
        jwt.verify(Token, process.env.JWT_SECRET_KEY);
        res.status(200).json({ status: httpStatusText.SUCCESS, data: { message: "true" } });
    } catch (err) {
        res.status(400).json({ status: httpStatusText.FAIL, data: { message: "false" } });
    } 
})

// const addAdmin = asyncWrapper(async (req, res, next) => {
//     const {firstName, lastName, phoneNumber, password} = req.body;
//     const hashedPassword = await bcrypt.hash(password, 10);
//     const admin = new Admin({
//         firstName,
//         lastName,
//         phoneNumber, 
//         password: hashedPassword
//     });
//     const token = await generateJWT({phoneNumber: admin.phoneNumber, id: admin._id, role: "admin"});
//     admin.token = token;
//     await admin.save();
//     res.status(201).json({ status: httpStatusText.SUCCESS, data: { admin: admin } });
// })
module.exports = {
    patientRegister,
    doctorRegister,
    login,
    verifyOtp,
    resendOtp,
    resetForForgetPassword,
    resetPassword,
    forgetPassword,
    verifyOtpForForgetPassword,
    getProfile,
    updateProfile,
    isValidSessionToken,
    // addAdmin
}