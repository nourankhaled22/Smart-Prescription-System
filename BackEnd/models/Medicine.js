const mongoose = require('mongoose');
const moment = require('moment-timezone');


const medicineSchema = new mongoose.Schema({
    nationalId: {
        type: String,
        required: true,
        trim: true
    },

    medicineName: {
        type: String,
        required: true,
        trim: true
    },

    frequency: {
        type: Number,
        default: 1
    },

    duration: {
        type: Number
    },

    dosage: {
        type: String
    },

    afterMeal: {
        type: Boolean
    },
    startDate: {
        type: Date,
        default: new Date(Date.now() + 3 * 60 * 60 * 1000)
    },

    startTime: {
        type: Date,
        default: new Date(Date.now() + 3 * 60 * 60 * 1000)
    },

    isActive: {
        type: Boolean,
        default: true
    },

    hoursPerDay: {
        type: Number,
        default: 24
    },

    nextDosageTime: {
        type: Date
    },

    scheduledTime: {
        type: Date
    },

    }, {
    timestamps: true
});

const Medicine = mongoose.model('Medicine', medicineSchema);

module.exports = Medicine;
