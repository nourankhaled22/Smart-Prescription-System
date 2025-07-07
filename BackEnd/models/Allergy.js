// name
// date

const mongoose = require('mongoose');

const allergySchema = new mongoose.Schema({
    nationalId: {
        type: String,
        required: true,
        trim: true
    },

    allergyName: {
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

const Allergy = mongoose.model('Allergy', allergySchema);

module.exports = Allergy;
