class HostController < BookingController
  before_action :move_to_signed_in

  def index
    @reservations = BookingDate.all.where("day >= ?", Date.current).where("day < ?", Date.current >> 3).order(day: :desc)
    book = BookingDate.where.not(name:"ホスト").where("day >= ?", Date.current).order(:day, time: :asc)
    @booking = []
    s_count = 0
    book.length.times do |num|
      if num == 0
        @booking[num] = book[num]
      elsif num >= 1
        if @booking[s_count].day == book[num].day && @booking[s_count].s_time == book[num].s_time && @booking[s_count].e_time == book[num].e_time && @booking[s_count].name == book[num].name
          next
        else
          s_count += 1
          @booking[s_count] = book[num]
        end
      end
      if s_count == 20
        break
      end
    end
  end

  def show
    date_time_now = params[:date_time]
    @reservation = BookingDate.find_by(date_time: date_time_now)
    @day = @reservation.day
  end

  def new 
    @reservation = BookingDate.new
    @day = params[:day]
    @time = params[:time]
    if @day && @time && @day.match(/\A\d{4}-\d{2}-\d{2}\z/)
      if @day.to_date.blank? || !(times.include?(@time))
        flash[:notice] = ["正しい日時が入力できてません"]
        redirect_to booking_date_path
      elsif @day.to_date < Date.current
        flash[:notice] =  ["過去の日付は選択できません", "正しい日付を選択してください"]
        redirect_to booking_date_path
      elsif @day.to_date < (Date.current + 1)
        flash[:notice] = ["当日は選択できません","正しい日付を選択してください"]
        redirect_to booking_date_path
      elsif (Date.current >> 2) < @day.to_date
        flash[:notice] =  ["2ヶ月以降の日付は選択できません。正しい日付を選択してください。"]
        redirect_to booking_date_path
      end
    else
      flash[:notice] = ["日時が正しく入力されていません。"]
      redirect_to booking_date_path
    end
  end

  def create
    s_hour = params[:s_time_hour]
    s_minute = params[:s_time_minute]
    e_hour = params[:e_time_hour]
    e_minute = params[:e_time_minute]
    if s_time_and_e_time_create(s_hour, s_minute, e_hour, e_minute)
      i = -2
    else
      s_time = @s_time
      e_time = @e_time
      @reservation = BookingDate.new(
        day: params[:day],
        time: times.index(s_time),
        s_time: s_time,
        e_time: e_time,
        name: 'ホスト',
        tell:  "00000000000",
        menu: 10,
        option: -1
      )
      @reservation[:date_time] = @reservation.day.to_s + s_time
      start_num = times.index(@reservation.s_time).to_i
      end_num = times.index(@reservation.e_time).to_i
      unless end_num
        end_num = start_num
      end
      i = end_num - start_num
      miss_count = 0
    end
    
    if i < 0
      @day = params[:day]
      @time = params[:time]
      flash[:notice] = ["入力方法が間違えています。", "最初からやり直してください。"]
      redirect_to host_new_path(day: @day)
    elsif i == 0
      if @reservation && @reservation.save 
        flash[:success] = ["#{s_time}に予定を入れました"]
        redirect_to host_path
      else
        flash[:notice] = ["予定を入れられませんでした。", "最初からやり直してください。"]
        redirect_to host_new_path(day: @day)
      end
    elsif i > 0
      i += 1
      ary = []
      i.times do |j|
        if @reservation && @reservation.save
          miss_count += 0 
        else
          ary.push("#{times[@reservation.time]}は予約が入っています。確認してください")
          miss_count += 1
        end
        time = times[start_num + j + 1].to_s
        date_time = @reservation.day.to_s + time
        @reservation = BookingDate.new(
          day: params[:day],
          time: times.index(time),
          date_time: date_time,
          s_time: s_time,
          e_time: e_time,
          name: 'ホスト',
          tell:  "00000000000",
          menu: 10,
          option: -1
        )
      end
      if miss_count > 0 
        flash[:notice] = ary
      end
      flash[:success] = ["予定入力しました。"]
      redirect_to host_path
    else
      flash[:notice] = ["入力していない箇所があります。"]
      redirect_to host_path
    end
  end

  def delete
    s_hour = params[:s_time_hour]
    s_minute = params[:s_time_minute]
    e_hour = params[:e_time_hour]
    e_minute = params[:e_time_minute]
    if s_time_and_e_time_create(s_hour, s_minute, e_hour, e_minute)
      @success_count = -1
    else
      day = params[:day]
      s_time = @s_time
      s_time_index = times.index(s_time)
      e_time = @e_time
      e_time_index = times.index(e_time)
      delete_command(day, s_time_index, e_time_index)
    end
    if @success_count == 0
      flash[:notice] = "該当する予定がありませんでした"
    elsif @success_count > 0
      flash[:success] = "該当する予定は削除されました"
    elsif @success_count < 0
      flash[:notice] = ["入力方法を間違えています。"]
    else 
      flash[:notice] = ["問題が発生しました。"]
    end
    redirect_to host_path
  end

  def host_logout
    session[:user_id] = nil
    flash[:notice] = "ホストをログアウトしました"
    redirect_to home_path
  end

  private
  def create_start_and_end_time(hour, minute)
    if minute == "30"
      create_minute = "30"
    else
      create_minute = "00"
    end 
    return hour.to_s + ":"  + create_minute
  end

  def delete_command(day, s_time_index, e_time_index)
    bookings = BookingDate.where(day: day, name: "ホスト", menu: 10, option: -1)
    @success_count = 0
    bookings.each do |book|
      (s_time_index .. e_time_index).each do |i|
        if book.time == i
          book.delete
          @success_count += 1
        end
      end
    end
    return @success_count
  end

  def s_time_and_e_time_create(s_hour, s_minute, e_hour, e_minute)
    if s_hour.blank? || s_minute.blank? || e_hour.blank? || e_minute.blank?
      return true
    else
      @s_time = create_start_and_end_time(s_hour, s_minute)
      @e_time = create_start_and_end_time(e_hour, e_minute)
      return false
    end
  end

  def move_to_signed_in
    if session[:user_id].nil?
      #サインインしていないユーザーはログインページが表示される
      flash[:notice] = "もう一度ホストにログインしてください"
      redirect_to home_path
    end
  end

  def times
    times = ["8:00",
             "8:30",
             "9:00",
             "9:30",
             "10:00",
             "10:30",
             "11:00",
             "11:30",
             "12:00",
             "12:30",
             "13:00",
             "13:30",
             "14:00",
             "14:30",
             "15:00",
             "15:30",
             "16:00",
             "16:30",
             "17:00",
             "17:30",
             "18:00",
             "18:30",
             "19:00",
             "19:30",
             "20:00",
             "20:30",
             "21:00"
            ]
  end
end