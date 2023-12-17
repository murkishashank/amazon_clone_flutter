const express = require("express");
const mangoose = require("mongoose");

const appRouter = require("./routes/auth");

const DB = "mongodb://localhost:27017/";
const PORT = 3000;
const app = express();

app.use(express.json())
app.use(appRouter);

mangoose
  .connect(DB)
  .then(() => {
    console.log("Connection Successful");
  })
  .catch((e) => {
    console.log("error", e);
  });

app.listen(PORT, () => console.log(`conntected at port ${PORT}`));
