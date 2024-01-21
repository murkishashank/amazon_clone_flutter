const jwt = require("jsonwebtoken");

const authMiddleware = async (req, res, next) => {
  try {
    const token = req.headers("x-auth-token");
    if (!token)
      return res.status(401).json({ message: "No token, access denied" });
    const isVerified = jwt.verify(token, "passwordKey");
    if (!isVerified)
      return res.status(401).json({ message: "No Authorised, access denied" });
    req.user = isVerified.id;
    req.token = token;
    next();
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

module.exports = authMiddleware;
