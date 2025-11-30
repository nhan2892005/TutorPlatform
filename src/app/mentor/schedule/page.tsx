import MentorScheduleManager from "@/components/mentor/MentorScheduleManager";
import { redirect } from "next/navigation";
import { getServerSession } from "next-auth";

export default async function MentorSchedulePage() {
  const session = await getServerSession();

  if (!session) {
    redirect("/auth/signin");
  }

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900 py-8">
      <MentorScheduleManager />
    </div>
  );
}
