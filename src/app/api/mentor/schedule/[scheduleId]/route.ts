import { getServerSession } from "next-auth";
import { NextRequest, NextResponse } from "next/server";
import { authOptions } from "@/app/api/auth/[...nextauth]/route";
import { prisma } from "@/lib/prisma";

export async function DELETE(
  request: NextRequest,
  { params }: { params: { scheduleId: string } }
) {
  try {
    const session = await getServerSession(authOptions);
    
    if (!session?.user?.id || session.user.role !== 'MENTOR') {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      );
    }

    const { scheduleId } = params;
    const scheduleIdNum = parseInt(scheduleId);

    // Verify the schedule belongs to this mentor
    const schedule = await prisma.lichTrong.findUnique({
      where: { maLichTrong: scheduleIdNum },
      include: {
        mentor: {
          include: {
            user: true
          }
        }
      }
    });

    if (!schedule) {
      return NextResponse.json(
        { error: 'Schedule not found' },
        { status: 404 }
      );
    }

    if (schedule.mentor.userId !== session.user.id) {
      return NextResponse.json(
        { error: 'Forbidden' },
        { status: 403 }
      );
    }

    // Delete the schedule
    await prisma.lichTrong.delete({
      where: { maLichTrong: scheduleIdNum }
    });

    return NextResponse.json({
      message: 'Schedule deleted successfully',
      scheduleId: scheduleIdNum
    });
  } catch (error) {
    console.error('Error deleting schedule:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}

export async function PATCH(
  request: NextRequest,
  { params }: { params: { scheduleId: string } }
) {
  try {
    const session = await getServerSession(authOptions);
    
    if (!session?.user?.id || session.user.role !== 'MENTOR') {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      );
    }

    const { scheduleId } = params;
    const scheduleIdNum = parseInt(scheduleId);
    const body = await request.json();
    const { startTime, endTime } = body;

    if (!startTime || !endTime) {
      return NextResponse.json(
        { error: 'Missing required fields: startTime, endTime' },
        { status: 400 }
      );
    }

    // Verify the schedule belongs to this mentor
    const schedule = await prisma.lichTrong.findUnique({
      where: { maLichTrong: scheduleIdNum },
      include: {
        mentor: {
          include: {
            user: true
          }
        }
      }
    });

    if (!schedule) {
      return NextResponse.json(
        { error: 'Schedule not found' },
        { status: 404 }
      );
    }

    if (schedule.mentor.userId !== session.user.id) {
      return NextResponse.json(
        { error: 'Forbidden' },
        { status: 403 }
      );
    }

    // Parse and validate times
    const [startHour, startMin] = startTime.split(':').map(Number);
    const [endHour, endMin] = endTime.split(':').map(Number);

    if (startHour >= endHour || (startHour === endHour && startMin >= endMin)) {
      return NextResponse.json(
        { error: 'Start time must be before end time' },
        { status: 400 }
      );
    }

    // Create ISO-8601 DateTime objects (Prisma requires DateTime format even for Time fields)
    const startDateTime = new Date(`1970-01-01T${String(startHour).padStart(2, '0')}:${String(startMin).padStart(2, '0')}:00Z`);
    const endDateTime = new Date(`1970-01-01T${String(endHour).padStart(2, '0')}:${String(endMin).padStart(2, '0')}:00Z`);

    // Update the schedule
    const updated = await prisma.lichTrong.update({
      where: { maLichTrong: scheduleIdNum },
      data: {
        gioBatDau: startDateTime,
        gioKetThuc: endDateTime
      }
    });

    return NextResponse.json({
      message: 'Schedule updated successfully',
      schedule: {
        id: updated.maLichTrong,
        date: updated.ngay.toISOString().split('T')[0],
        startTime: updated.gioBatDau,
        endTime: updated.gioKetThuc
      }
    });
  } catch (error) {
    console.error('Error updating schedule:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
