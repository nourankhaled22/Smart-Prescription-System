module.exports = (phoneNumber) => {
    const phoneRegex = /^((01)|(\\+201))[0125][0-9]{8}$/;
    if (phoneRegex.test(phoneNumber)) {
        return true;
    } else {
        return false;
    }
}