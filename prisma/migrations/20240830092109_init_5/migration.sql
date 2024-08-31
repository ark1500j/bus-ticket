/*
  Warnings:

  - You are about to drop the column `busId` on the `Trip` table. All the data in the column will be lost.
  - You are about to drop the column `fromId` on the `Trip` table. All the data in the column will be lost.
  - You are about to drop the column `toId` on the `Trip` table. All the data in the column will be lost.
  - Added the required column `busNumber` to the `Trip` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "Trip" DROP CONSTRAINT "Trip_busId_fkey";

-- AlterTable
ALTER TABLE "Trip" DROP COLUMN "busId",
DROP COLUMN "fromId",
DROP COLUMN "toId",
ADD COLUMN     "busNumber" TEXT NOT NULL,
ALTER COLUMN "amount" SET DATA TYPE TEXT;

-- AddForeignKey
ALTER TABLE "Trip" ADD CONSTRAINT "Trip_busNumber_fkey" FOREIGN KEY ("busNumber") REFERENCES "Bus"("busNumber") ON DELETE RESTRICT ON UPDATE CASCADE;
