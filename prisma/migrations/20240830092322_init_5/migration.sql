-- DropForeignKey
ALTER TABLE "Trip" DROP CONSTRAINT "Trip_createdId_fkey";

-- AlterTable
ALTER TABLE "Trip" ALTER COLUMN "createdId" SET DATA TYPE TEXT;

-- AddForeignKey
ALTER TABLE "Trip" ADD CONSTRAINT "Trip_createdId_fkey" FOREIGN KEY ("createdId") REFERENCES "Admin"("email") ON DELETE RESTRICT ON UPDATE CASCADE;
