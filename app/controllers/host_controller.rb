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
  end

  def new 
    @reservation = BookingDate.new
    @day = params[:day]
    @time = params[:time]
  end

  def create
    create_start_and_end_time(params[:s_time_minute], params[:s_time_hour])
    s_time = @create_time
    create_start_and_end_time(params[:e_time_minute], params[:e_time_hour])
    e_time = @create_time
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
    if i < 0
      flash[:notice] = ["入力方法が間違えています。", "最初からやり直してください。"]
      redirect_to host_new_path
    elsif i == 0
      if @reservation && @reservation.save 
        flash[:success] = ["#{s_time}に予定を入れました"]
        redirect_to host_path
      else
        flash[:notice] = ["予定を入れられませんでした。", "最初からやり直してください。"]
        redirect_to host_new_path
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
    
  end

  def host_logout
    session[:user_id] = nil
    redirect_to home_path
  end

  def move_to_signed_in
    if session[:user_id].nil?
      #サインインしていないユーザーはログインページが表示される
      redirect_to home_path
    end
  end

  private
  def create_start_and_end_time(minute, hour)
    if minute == "30"
      create_minute = "30"
    else
      create_minute = "00"
    end
    @create_time = hour.to_s + ":"  + create_minute
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