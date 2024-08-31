/*
  Warnings:

  - A unique constraint covering the columns `[busNumber]` on the table `Bus` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "Bus_busNumber_key" ON "Bus"("busNumber");
