// disease name
// date

const mongoose = require('mongoose');

const chronicDiseaseSchema = new mongoose.Schema({
    nationalId: {
        type: String,
        required: true,
        trim: true
    },
    
    diseaseName: {
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

const ChronicDisease = mongoose.model('ChronicDisease', chronicDiseaseSchema);

module.exports = ChronicDisease;
