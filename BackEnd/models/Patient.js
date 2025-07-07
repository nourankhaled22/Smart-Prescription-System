// firstName
// lastName
// national id
// phone number
// role
// password
// date of birth
// status -> active , suspended

const mongoose = require('mongoose');

const chatSchema = new mongoose.Schema({
    role: {
        type: String,
        required: true,
    },
    content: {
        type: String,
        required: true,
    },
}); 

const patientSchema = new mongoose.Schema({
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

    nationalId: {
        type: String,
        required: true,
        trim: true,
        unique: true
    },

    phoneNumber: {
        type: String,
        required: true,
        unique: true,
        trim: true
    },

    role: {
        type: String,
        default: 'patient',
        enum: ['patient']
    },

    password: {
        type: String,
        required: true,
        trim: true
    },

    dateOfBirth: {
        type: Date,
        required: true
    },

    status: {
        type: String,
        enum: ['active', 'suspended'],
        default: 'active'
    },

    token: {
        type: String
    },
    chats: [chatSchema],
    address: {
        type: String,
        trim: true
    }
    }, {
    timestamps: true
});

const Patient = mongoose.model('Patient', patientSchema);

module.exports = Patient;
