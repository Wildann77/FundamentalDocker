const express = require("express");
const cors = require("cors");
const sequelize = require("./config/database");
const userRoutes = require("./routes/user.routes");

const app = express();
app.use(cors());
app.use(express.json());

app.use("/users", userRoutes);

sequelize.sync({ alter: true })
  .then(() => console.log("Database connected"))
  .catch(err => console.error(err));

app.listen(3000, () => {
  console.log("Server running on port 3000");
});