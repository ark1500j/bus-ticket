/*
  Warnings:

  - You are about to drop the column `make` on the `Bus` table. All the data in the column will be lost.
  - You are about to drop the column `createdBy` on the `Trip` table. All the data in the column will be lost.
  - You are about to drop the column `createdByName` on the `Trip` table. All the data in the column will be lost.
  - You are about to drop the `Location` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `_TripStops` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `createdId` to the `Trip` table without a default value. This is not possible if the table is not empty.
  - Added the required column `from` to the `Trip` table without a default value. This is not possible if the table is not empty.
  - Added the required column `to` to the `Trip` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "Trip" DROP CONSTRAINT "Trip_fromId_fkey";

-- DropForeignKey
ALTER TABLE "Trip" DROP CONSTRAINT "Trip_toId_fkey";

-- DropForeignKey
ALTER TABLE "_TripStops" DROP CONSTRAINT "_TripStops_A_fkey";

-- DropForeignKey
ALTER TABLE "_TripStops" DROP CONSTRAINT "_TripStops_B_fkey";

-- AlterTable
ALTER TABLE "Bus" DROP COLUMN "make",
ALTER COLUMN "createdAt" SET DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "Trip" DROP COLUMN "createdBy",
DROP COLUMN "createdByName",
ADD COLUMN     "createdId" INTEGER NOT NULL,
ADD COLUMN     "from" TEXT NOT NULL,
ADD COLUMN     "stops" TEXT[],
ADD COLUMN     "to" TEXT NOT NULL;

-- DropTable
DROP TABLE "Location";

-- DropTable
DROP TABLE "_TripStops";

-- DropEnum
DROP TYPE "LocationEnum";

-- CreateTable
CREATE TABLE "Admin" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "Company" TEXT NOT NULL,

    CONSTRAINT "Admin_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Admin_id_key" ON "Admin"("id");

-- AddForeignKey
ALTER TABLE "Trip" ADD CONSTRAINT "Trip_createdId_fkey" FOREIGN KEY ("createdId") REFERENCES "Admin"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
