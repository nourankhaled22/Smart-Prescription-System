module.exports = (password) => {
    const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{6,}$/;
    if (passwordRegex.test(password)) {
        return true;
    } else {
        return false;
    }
}
// (?=.*[a-z]) → Must contain at least one lowercase letter
// (?=.*[A-Z]) → Must contain at least one uppercase letter
// (?=.*\d) → Must contain at least one digit
// .{6,} → Minimum 6 characters total
// $ → End of string