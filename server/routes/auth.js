const express = require("express");
const User = require("../models/user");
const bcryptjs = require("bcryptjs");
const jwt = require("jsonwebtoken");
const authMiddleware = require("../middlewares/auth");

const authRouter = express.Router();

authRouter.post("/api/v1/signup", async (req, res) => {
  try {
    const { name = "", email = "", password = "" } = req.body || {};

    const existingUser = await User.findOne({ email });

    if (existingUser) {
      return res
        .status(400)
        .json({ message: "User with same email already exists!" });
    }

    const hashedPassword = await bcryptjs.hash(password, 8);

    var user = new User({
      name,
      email,
      password: hashedPassword,
    });

    user = await user.save();
    res.status(200).json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

authRouter.post("/api/v1/signin", async (req, res) => {
  try {
    const { email = "", password = "" } = req.body || {};
    const hashedPassword = await bcryptjs.hash(password, 8);

    const user = await User.findOne({ email });

    if (!user) {
      return res
        .status(400)
        .json({ message: "User with this email dose not exists!" });
    }

    const isMatch = bcryptjs.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: "Incorrect Password." });
    }

    const token = jwt.sign({ id: user._id }, "passwordKey");

    res.json({ ...user._doc, token });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

authRouter.post("/tokenIsValid", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) return res.json(false);
    const isVerified = jwt.verify(token, "passwordKey");
    if (!isVerified) return res.json(false);
    const user = await User.findById(isVerified.id);
    if (!user) return res.json(false);
    console.log("true")
    return res.json(true);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//get user data
authRouter.get("/", authMiddleware, async (req, res) => {
  const user = await User.findById(req.id);

  return res.json({ ...user._doc, token: req.token });
});

module.exports = authRouter;
