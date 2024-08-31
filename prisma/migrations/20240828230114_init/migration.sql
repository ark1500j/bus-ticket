-- CreateEnum
CREATE TYPE "TripType" AS ENUM ('OneWay', 'RoundTrip');

-- CreateEnum
CREATE TYPE "BusStatus" AS ENUM ('InService', 'NeedsMaintenance', 'UnderMaintenance');

-- CreateEnum
CREATE TYPE "LocationEnum" AS ENUM ('Kumasi_Asfo', 'Accra_Circle');

-- CreateTable
CREATE TABLE "Trip" (
    "id" SERIAL NOT NULL,
    "type" "TripType" NOT NULL,
    "createdBy" INTEGER NOT NULL,
    "createdByName" TEXT NOT NULL,
    "fromId" INTEGER NOT NULL,
    "toId" INTEGER NOT NULL,
    "departureDate" TIMESTAMP(3) NOT NULL,
    "arrivalTime" TIMESTAMP(3) NOT NULL,
    "returnDate" TIMESTAMP(3),
    "amount" DOUBLE PRECISION NOT NULL,
    "numberOfSeats" INTEGER NOT NULL,
    "seatsBooked" TEXT[],
    "busId" INTEGER NOT NULL,

    CONSTRAINT "Trip_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Booking" (
    "id" SERIAL NOT NULL,
    "seatNumbers" TEXT[],
    "adminId" INTEGER NOT NULL,
    "email" TEXT NOT NULL,
    "userId" INTEGER NOT NULL,
    "notes" TEXT,
    "additionalLuggageCount" INTEGER NOT NULL,
    "specialLuggageCount" INTEGER NOT NULL,
    "totalAmount" DOUBLE PRECISION NOT NULL,
    "tripId" INTEGER NOT NULL,

    CONSTRAINT "Booking_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Adult" (
    "id" SERIAL NOT NULL,
    "firstName" TEXT NOT NULL,
    "lastName" TEXT NOT NULL,
    "bookingId" INTEGER NOT NULL,

    CONSTRAINT "Adult_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Child" (
    "id" SERIAL NOT NULL,
    "firstName" TEXT NOT NULL,
    "lastName" TEXT NOT NULL,
    "bookingId" INTEGER NOT NULL,

    CONSTRAINT "Child_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Location" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Location_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Bus" (
    "id" SERIAL NOT NULL,
    "busNumber" TEXT NOT NULL,
    "status" "BusStatus" NOT NULL,
    "lastMaintenance" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "make" TEXT NOT NULL,

    CONSTRAINT "Bus_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_TripStops" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "_TripStops_AB_unique" ON "_TripStops"("A", "B");

-- CreateIndex
CREATE INDEX "_TripStops_B_index" ON "_TripStops"("B");

-- AddForeignKey
ALTER TABLE "Trip" ADD CONSTRAINT "Trip_fromId_fkey" FOREIGN KEY ("fromId") REFERENCES "Location"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Trip" ADD CONSTRAINT "Trip_toId_fkey" FOREIGN KEY ("toId") REFERENCES "Location"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Trip" ADD CONSTRAINT "Trip_busId_fkey" FOREIGN KEY ("busId") REFERENCES "Bus"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Booking" ADD CONSTRAINT "Booking_tripId_fkey" FOREIGN KEY ("tripId") REFERENCES "Trip"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Adult" ADD CONSTRAINT "Adult_bookingId_fkey" FOREIGN KEY ("bookingId") REFERENCES "Booking"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Child" ADD CONSTRAINT "Child_bookingId_fkey" FOREIGN KEY ("bookingId") REFERENCES "Booking"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_TripStops" ADD CONSTRAINT "_TripStops_A_fkey" FOREIGN KEY ("A") REFERENCES "Location"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_TripStops" ADD CONSTRAINT "_TripStops_B_fkey" FOREIGN KEY ("B") REFERENCES "Trip"("id") ON DELETE CASCADE ON UPDATE CASCADE;
