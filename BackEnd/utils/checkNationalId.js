module.exports = (nationalId) => {
    const nationalIdRegex = /^([123][0-9]{2}(0[1-9]|(10|11|12))(0[1-9]|[12][0-9]|3[01])(0[1-9]|[1-7][0-9]|8[0-8])[0-9]{5})$/;
    if (nationalIdRegex.test(nationalId)) {
        return true;
    } else {
        return false;
    }
}