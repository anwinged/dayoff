const STATUS_OVERTIME = 'overtime';

class TimeSpan {
  static fromObject({ hours, minutes, status }) {
    return new TimeSpan(hours, minutes, status);
  }

  constructor(hours, minutes, status) {
    this.hours = hours;
    this.minutes = minutes;
    this.status = status;
  }

  isOvertime() {
    return this.status === STATUS_OVERTIME;
  }

  toStr() {
    const sign = this.isOvertime() ? '+' : '';
    return sign + this.hours + ':' + String(this.minutes).padStart(2, '0');
  }
}

export default TimeSpan;
