// firstName
// lastName
// phone number
// role
// password
// date of birth
// clinic address
// specialization
// licence file name
// status  -> active , suspended , unverified

const mongoose = require('mongoose');

const doctorSchema = new mongoose.Schema({
    firstName: {
        type: String,
        required: true,
        trim: true
    },

    lastName: {
        type: String,
        required: true,
        trim: true
    },

    phoneNumber: {
        type: String,
        required: true,
        unique: true,
    },

    role: {
        type: String,
        default: 'doctor',
        enum: ['doctor']
    },

    password: {
        type: String,
        trim: true,
        required: true,
    },

    dateOfBirth: {
        type: Date,
        required: true
    },

    clinicAddress: {
        type: String,
        required: true,
        trim: true
    },

    specialization: {
        type: String,
        required: true,
        trim: true
    },

    licenceUrl: {
        type: String,
    },
    
    licencePublicId : {
        type: String
    },
    
    status: {
        type: String,
        enum: ['active', 'suspended', 'unverified'],
        default: 'unverified'
    },

    token: {
        type: String
    }
    }, {
    timestamps: true
});

const Doctor = mongoose.model('Doctor', doctorSchema);

module.exports = Doctor;
