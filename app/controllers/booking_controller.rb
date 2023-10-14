class BookingController < ApplicationController
  def index
      @reservations = BookingDate.all.where("day >= ?", Date.current).where("day < ?", Date.current >> 3).order(day: :desc)
  end

  def new
    @reservation = BookingDate.new
    @day = params[:day]
    @time = params[:time]
    @start_time = DateTime.parse(@day + " " + @time + " " + "JST")
    if @day.to_date < Date.current
      flash[:notice] =  "過去の日付は選択できません。正しい日付を選択してください。"
      redirect_to booking_date_path
    elsif @day.to_date < (Date.current + 1)
      flash[:notice] = "当日は選択できません。正しい日付を選択してください。"
      redirect_to booking_date_path
    elsif (Date.current >> 3) < @day.to_date
      flash[:notice] =  "3ヶ月以降の日付は選択できません。正しい日付を選択してください。"
      redirect_to booking_date_path
    end
  end

  def show
    @reservation = BookingDate.find(params[:id])
  end

  def create
    @reservation = BookingDate.new(
      day: params[:day],
      time: params[:time],
      start_time: params[:start_time],
      name: params[:name],
      tell: params[:tell],
      menu: params[:menu]
    )
    @booking = @reservation
    create_date_time
    @reservation[:date_time] = @date_time

    if @reservation[:menu].nil?
      flash[:notice] = "メニューを選択してください"
    elsif @reservation[:menu] % 2 == 0
    time1 = params[:time]
      if time1.end_with?("00")
        time1 = time1[..-2-1] + "30"
        @reservation1 = BookingDate.new(
        day: params[:day],
        time: time1,
        start_time: params[:start_time],
        name: params[:name],
        tell: params[:tell],
        menu: params[:menu]
        )
      else 
        time1 = (time1[..-3-1].to_i + 1).to_s+ ":00"
        @reservation1 = BookingDate.new(
        day: params[:day],
        time: time1,
        start_time: params[:start_time],
        name: params[:name],
        tell: params[:tell],
        menu: params[:menu]
        )
      end
      @booking = @reservation1
      create_date_time
      @reservation1[:date_time] = @date_time
    elsif @reservation[:menu] == 5
      a = 1 + 1
    elsif @reservation[:menu] % 2 == 1
      time1 = params[:time]
      if time1.end_with?("00")
        time2 = (time1[..-3-1].to_i + 1).to_s+ ":00"
        time1 = time1[..-2-1] + "30"
        @reservation1 = BookingDate.new(
        day: params[:day],
        time: time1,
        start_time: params[:start_time],
        name: params[:name],
        tell: params[:tell],
        menu: params[:menu]
        )
        @reservation2 = BookingDate.new(
        day: params[:day],
        time: time2,
        start_time: params[:start_time],
        tell: params[:tell],
        name: params[:name],
        menu: params[:menu]
        )
      else 
        time1 = (time1[..-3-1].to_i + 1).to_s+ ":00"
        time2 = time1[..-2-1] + "30"
        @reservation1 = BookingDate.new(
        day: params[:day],
        time: time1,
        start_time: params[:start_time],
        name: params[:name],
        tell: params[:tell],
        menu: params[:menu]
        )
        @reservation2 = BookingDate.new(
        day: params[:day],
        time: time2,
        start_time: params[:start_time],
        name: params[:name],
        tell: params[:tell],
        menu: params[:menu]
        )
      end
      @booking = @reservation1
      create_date_time
      @reservation1[:date_time] = @date_time
      @booking = @reservation2
      create_date_time
      @reservation2[:date_time] = @date_time
    end

    if @reservation2.nil?
      if @reservation1.nil?
        if @reservation.save
          redirect_to booking_date_path
        else
          flash[:notice] = ["未入力のものがあります"]
          redirect_to booking_date_path
        end
      else
        if @reservation1.save && @reservation.save
          redirect_to booking_date_path
        else
          flash[:notice] = ["そのメニューでは予約できません","未入力のものがあります"]
          redirect_to booking_date_path
        end
      end
    else 
      if @reservation1.save && @reservation.save && @reservation2.save
        redirect_to booking_date_path
      else
        flash[:notice] = ["そのメニューでは予約できません", "未入力のものがあります","入力形式が間違えています"]
        redirect_to booking_date_path
      end
    end
  end

  def self.booking_after_two_month
    @reservations = BookingDate.all.where("day >= ?", Date.current).where("day < ?", Date.current >> 3).order(day: :desc)
    reservation_data = []
    @reservations.each do |reservation|
      reservations_hash = {}
      reservations_hash.merge!(day: reservation.day.strftime("%Y-%m-%d"), time: reservation.time)
      reservation_data.push(reservations_hash)
    end
    reservation_data
  end

  def host
    @host = Host.new
  end

  def host_login
    @host = Host.new(
      password: params[:password]
    )
    key = Host.find_by(id: 1)
    if @host[:password] != key[:password]
      redirect_to "/"
    else
      session[:user_id] = key[:id]
      redirect_to host_path
    end
  end

  private
  def reservation_params
    params.require(:booking_date).permit(:day, :time, :start_time)
  end

  def create_date_time
    date = @booking.day.to_s
    time = @booking.time
    @date_time = date + time
  end
end