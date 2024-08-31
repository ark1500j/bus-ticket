/*
  Warnings:

  - You are about to drop the column `adminId` on the `Booking` table. All the data in the column will be lost.
  - You are about to drop the column `userId` on the `Booking` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Booking" DROP COLUMN "adminId",
DROP COLUMN "userId",
ALTER COLUMN "totalAmount" SET DATA TYPE TEXT;
