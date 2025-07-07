// name
// date

const mongoose = require('mongoose');

const vaccineSchema = new mongoose.Schema({
    nationalId: {
        type: String,
        required: true,
        trim: true
    },

    vaccineName: {
        type: String,
        required: true,
        trim: true
    },

    date: {
        type: Date,
        required: true
    }
    }, {
    timestamps: true
});

const Vaccine = mongoose.model('Vaccine', vaccineSchema);

module.exports = Vaccine;
