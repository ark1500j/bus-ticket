/*
  Warnings:

  - You are about to drop the column `createdId` on the `Trip` table. All the data in the column will be lost.
  - Added the required column `adminEmail` to the `Trip` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "Trip" DROP CONSTRAINT "Trip_createdId_fkey";

-- AlterTable
ALTER TABLE "Trip" DROP COLUMN "createdId",
ADD COLUMN     "adminEmail" TEXT NOT NULL;

-- AddForeignKey
ALTER TABLE "Trip" ADD CONSTRAINT "Trip_adminEmail_fkey" FOREIGN KEY ("adminEmail") REFERENCES "Admin"("email") ON DELETE RESTRICT ON UPDATE CASCADE;
