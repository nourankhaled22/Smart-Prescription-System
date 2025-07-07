// firstName
// lastName
// phone number
// role
// password

const mongoose = require('mongoose');

const adminSchema = new mongoose.Schema({
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
        match: [/^\d{10,15}$/, 'Please enter a valid phone number']
    },

    role: {
        type: String,
        default: 'admin',
        enum: ['admin']
    },

    password: {
        type: String,
        required: true,
        minlength: 6
    },

    token: {
        type: String
    }
    }, {
    timestamps: true
});

const Admin = mongoose.model('Admin', adminSchema);

module.exports = Admin;
