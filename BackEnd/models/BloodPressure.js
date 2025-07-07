// pulse
// diastolic
// systolic
// date

const mongoose = require('mongoose');

const bloodPressureSchema = new mongoose.Schema({
    nationalId: {
        type: String,
        required: true,
        trim: true
    },
    
    pulse: {
        type: Number,
        required: true,
        min: [40, 'Pulse must be at least 40 bpm'],
        max: [180, 'Pulse must be no more than 180 bpm']
    },

    diastolic: {
        type: Number,
        required: true,
        min: [40, 'Diastolic must be at least 40 mmHg'],
        max: [120, 'Diastolic must be no more than 120 mmHg']
    },

    systolic: {
        type: Number,
        required: true,
        min: [70, 'Systolic must be at least 70 mmHg'],
        max: [200, 'Systolic must be no more than 200 mmHg']
    },

    date: {
        type: Date,
        required: true
    }
    }, {
    timestamps: true
});

const BloodPressure = mongoose.model('BloodPressure', bloodPressureSchema);

module.exports = BloodPressure;
