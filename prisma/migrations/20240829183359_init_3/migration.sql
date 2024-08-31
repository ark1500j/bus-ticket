/*
  Warnings:

  - A unique constraint covering the columns `[email]` on the table `Admin` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `email` to the `Admin` table without a default value. This is not possible if the table is not empty.
  - Added the required column `adminEmail` to the `Bus` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Admin" ADD COLUMN     "email" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "Bus" ADD COLUMN     "adminEmail" TEXT NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "Admin_email_key" ON "Admin"("email");

-- AddForeignKey
ALTER TABLE "Bus" ADD CONSTRAINT "Bus_adminEmail_fkey" FOREIGN KEY ("adminEmail") REFERENCES "Admin"("email") ON DELETE RESTRICT ON UPDATE CASCADE;
