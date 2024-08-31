import express from "express";
import { Request, Response } from "express";
import prisma from "./utils";
import bodyParser from "body-parser";
import { Bus, TripType } from "@prisma/client";
import cors from "cors";

const app = express();

const allowedOrigins = ["http://localhost:5173", "https://www.google.com"];

app.use(
  cors({
    origin: (origin, callback) => {
      if (!origin || allowedOrigins.includes(origin)) {
        callback(null, origin); // Reflect the origin in the Access-Control-Allow-Origin header
      } else {
        callback(new Error("Not allowed by CORS"));
      }
    },
    methods: ["GET", "POST", "PUT", "DELETE"],
    allowedHeaders: ["Content-Type", "Authorization"],
  })
);

app.use(bodyParser.urlencoded({ extended: true }));

// Parse application/json
app.use(bodyParser.json());

app.get("/", (req: Request, res: Response) => {
  const data = { name: "emmanuel" };
  res.json(data);
});
app
  .route("/buses")
  .get(async (req: Request, res: Response) => {
    const buses = await prisma.bus.findMany();
    res.json(buses);
  })
  .post(async (req: Request, res: Response) => {
    try {
      const { email, busNumber, status, lastMaintenance } = req.body;
      const bus = await prisma.bus.create({
        data: {
          busNumber,
          lastMaintenance,
          status,
          admin: { connect: { email } },
        },
      });
      console.log(bus);
      if (!bus) {
        return res.status(400).json({
          success: false,
          message: "Failed to create the bus.",
          code: 400,
        });
      }

      res.status(201).json({
        success: true,
        message: "Bus created successfully",
        code: 201,
        data: bus,
      });
    } catch (error) {
      console.error(error);

      res.status(500).json({
        success: false,
        message: "An error occurred while creating the bus.",
        code: 500,
        error: error, // Optional: Send the error message in the response
      });
    }
  })
  .put(async (req: Request, res: Response) => {
    try {
      const { busNumber, status, lastMaintenance }: Partial<Bus> = req.body;
      const bus_exits = await prisma.bus.findUnique({ where: { busNumber } });
      if (!bus_exits) {
      }

      const bus = await prisma.bus.update({
        where: { busNumber },
        data: {
          ...(status && { status }), // Update only if status is provided
          ...(lastMaintenance && { lastMaintenance }),
        },
      });

      if (!bus) {
        return res.status(400).json({
          success: false,
          message: "Failed to create the bus.",
          code: 400,
        });
      }
      console.log(bus);
      res.status(201).json({
        success: true,
        message: "Bus created successfully",
        code: 201,
        data: bus,
      });
    } catch (error) {
      console.error(error);

      res.status(500).json({
        success: false,
        message: "An error occurred while updating the bus.",
        code: 500,
        error: error, // Optional: Send the error message in the response
      });
    }
  })
  .delete(async (req: Request, res: Response) => {
    try {
      const { busNumber }: Partial<Bus> = req.body;
      const bus = await prisma.bus.delete({ where: { busNumber } });
      if (!bus) {
        return res.status(400).json({
          success: false,
          message: "Failed to create the bus.",
          code: 400,
        });
      }

      res.status(202).json({
        success: true,
        message: "Bus created successfully",
        code: 201,
        data: bus,
      });
    } catch (error) {
      console.error(error);

      res.status(500).json({
        success: false,
        message: "An error occurred while deleting the bus.",
        code: 500,
        error: error,
      });
    }
  });

app
  .route("/trips")
  .get(async (req: Request, res: Response) => {
    const trips = await prisma.trip.findMany();
    console.log(trips);
    res.json(trips);
  })
  .post(async (req: Request, res: Response) => {
    const {
      type,
      from,
      to,
      busNumber,
      departureDate,
      arrivalTime,
      returnDate,
      amount,
      numberOfSeats,
      seatsBooked,
      email,
    } = req.body;

    try {
      const newTrip = await prisma.trip.create({
        data: {
          type,
          admin: {
            connect: { email }, // Connects to the Admin using email
          },
          bus: {
            connect: { busNumber }, // Connects to the Bus using busNumber
          },
          from,
          to,
          departureDate: new Date(departureDate),
          arrivalTime: new Date(arrivalTime),
          returnDate:
            returnDate && type === "RoundTrip" ? new Date(returnDate) : null,
          amount,
          numberOfSeats,
          seatsBooked,
        },
      });
      res.status(201).json(newTrip);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: "Failed to create trip" });
    }
  })
  .put(async (req: Request, res: Response) => {
    const {
      id,
      type,
      from,
      to,
      departureDate,
      arrivalTime,
      returnDate,
      amount,
      numberOfSeats,
    } = req.body;

    const data: any = {};

    if (type) data.type = type as TripType;
    if (from) data.from = from;
    if (to) data.to = to;
    if (departureDate) data.departureDate = new Date(departureDate);
    if (arrivalTime) data.arrivalTime = new Date(arrivalTime);
    if (returnDate) data.returnDate = new Date(returnDate);
    if (amount) data.amount = amount;
    if (numberOfSeats) data.numberOfSeats = numberOfSeats;

    try {
      const updatedTrip = await prisma.trip.update({
        where: { id: parseInt(id) },
        data,
      });

      if (!updatedTrip) {
        return res.status(404).json({
          success: false,
          message: "Trip not found.",
          code: 404,
        });
      }

      res.status(204).json({
        success: true,
        message: "Trip updated successfully",
        code: 204,
        data: updatedTrip,
      });
    } catch (error) {
      console.error("Error updating trip:", error);
      res.status(500).json({
        success: false,
        message: "An error occurred while updating the trip.",
        code: 500,
        error: error, // Send the error message in the response
      });
    }
  })
  .delete(async (req: Request, res: Response) => {
    try {
      const { id } = req.body;
      const trip = await prisma.trip.delete({ where: { id } });

      if (!trip) {
        return res.status(400).json({
          success: false,
          message: "Failed to create the bus.",
          code: 400,
        });
      }

      res.status(202).json({
        success: true,
        message: "Bus created successfully",
        code: 202,
        data: trip,
      });
    } catch (error) {
      console.error(error);

      res.status(500).json({
        success: false,
        message: "An error occurred while deleting the bus.",
        code: 500,
        error: error, // Optional: Send the error message in the response
      });
    }
  });

app
  .route("/bookings")
  .get(async (req: Request, res: Response) => {
    try {
      const { email } = req.body;
      const bookings = await prisma.booking.findMany({ where: { email } });
      res.json(bookings);
    } catch (error) {
      console.log(error);
      res.status(500).json({
        success: false,
        message: "An error occurred while deleting the bus.",
        code: 500,
        error: error, // Optional: Send the error message in the response
      });
    }
  })
  .post(async (req: Request, res: Response) => {
    const {
      seatNumbers,
      email,
      adults,
      children,
      additionalLuggageCount,
      specialLuggageCount,
      totalAmount,
      tripId,
    } = req.body;

    try {
      const newBooking = await prisma.booking.create({
        data: {
          seatNumbers,
          email,
          additionalLuggageCount: additionalLuggageCount || 0,
          specialLuggageCount: specialLuggageCount || 0,
          totalAmount,
          trip: { connect: { id: tripId } },
          adults: {
            create: adults,
          },
          children: {
            create: children,
          },
        },
      });

      res.status(201).json({
        success: true,
        message: "Booking created successfully",
        data: newBooking,
      });
    } catch (error) {
      console.error(error);
      res.status(500).json({
        success: false,
        message: "An error occurred while creating the booking.",
        error: error,
      });
    }
  });

app.listen(3000, () => {
  console.log("server running on port 3000");
});
