import { getServerSession } from "next-auth";
import { NextRequest, NextResponse } from "next/server";
import { authOptions } from "@/app/api/auth/[...nextauth]/route";
import { prisma } from "@/lib/prisma";

export async function GET(request: NextRequest) {
  try {
    const session = await getServerSession(authOptions);
    
    if (!session?.user?.id || session.user.role !== 'MENTOR') {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      );
    }

    const mentorId = session.user.id;

    // Get mentor profile to get mentorProfileId
    const mentorProfile = await prisma.mentorProfile.findUnique({
      where: { userId: mentorId }
    });

    if (!mentorProfile) {
      return NextResponse.json(
        { error: 'Mentor profile not found' },
        { status: 404 }
      );
    }

    // Get all available schedules for this mentor
    const schedules = await prisma.lichTrong.findMany({
      where: { mentorId: mentorProfile.id },
      orderBy: [
        { ngay: 'asc' },
        { gioBatDau: 'asc' }
      ]
    });

    const formattedSchedules = schedules.map((schedule: any) => ({
      id: schedule.maLichTrong,
      date: schedule.ngay.toISOString().split('T')[0],
      startTime: schedule.gioBatDau,
      endTime: schedule.gioKetThuc,
      dayOfWeek: schedule.ngay.toLocaleDateString('vi-VN', { weekday: 'long' })
    }));

    return NextResponse.json({
      schedules: formattedSchedules,
      mentorProfileId: mentorProfile.id
    });
  } catch (error) {
    console.error('Error fetching schedules:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}

export async function POST(request: NextRequest) {
  try {
    const session = await getServerSession(authOptions);
    
    if (!session?.user?.id || session.user.role !== 'MENTOR') {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      );
    }

    const body = await request.json();
    const { date, startTime, endTime } = body;

    if (!date || !startTime || !endTime) {
      return NextResponse.json(
        { error: 'Missing required fields: date, startTime, endTime' },
        { status: 400 }
      );
    }

    const mentorProfile = await prisma.mentorProfile.findUnique({
      where: { userId: session.user.id }
    });

    if (!mentorProfile) {
      return NextResponse.json(
        { error: 'Mentor profile not found' },
        { status: 404 }
      );
    }

    // Parse date and times
    const scheduleDate = new Date(date);
    const [startHour, startMin] = startTime.split(':').map(Number);
    const [endHour, endMin] = endTime.split(':').map(Number);

    // Validate time format
    if (startHour >= endHour || (startHour === endHour && startMin >= endMin)) {
      return NextResponse.json(
        { error: 'Start time must be before end time' },
        { status: 400 }
      );
    }

    // Create ISO-8601 DateTime objects (Prisma requires DateTime format even for Time fields)
    const startDateTime = new Date(`1970-01-01T${String(startHour).padStart(2, '0')}:${String(startMin).padStart(2, '0')}:00Z`);
    const endDateTime = new Date(`1970-01-01T${String(endHour).padStart(2, '0')}:${String(endMin).padStart(2, '0')}:00Z`);

    // Check for overlapping schedules on the same day
    const existingSchedule = await prisma.lichTrong.findFirst({
      where: {
        mentorId: mentorProfile.id,
        ngay: {
          gte: new Date(scheduleDate.setHours(0, 0, 0, 0)),
          lt: new Date(new Date(scheduleDate).setHours(24, 0, 0, 0))
        }
      }
    });

    if (existingSchedule) {
      return NextResponse.json(
        { error: 'Schedule already exists for this date' },
        { status: 400 }
      );
    }

    // Create new schedule
    const newSchedule = await prisma.lichTrong.create({
      data: {
        mentorId: mentorProfile.id,
        ngay: scheduleDate,
        gioBatDau: startDateTime,
        gioKetThuc: endDateTime
      }
    });

    return NextResponse.json({
      message: 'Schedule created successfully',
      schedule: {
        id: newSchedule.maLichTrong,
        date: newSchedule.ngay.toISOString().split('T')[0],
        startTime: newSchedule.gioBatDau,
        endTime: newSchedule.gioKetThuc
      }
    });
  } catch (error) {
    console.error('Error creating schedule:', error);
    return NextResponse.json(
      { error: (error as any)?.message || 'Internal server error' },
      { status: 500 }
    );
  }
}
