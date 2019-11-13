<template>
  <div id="app">
    <section class="timer" v-bind:class="{ overtime: isOvertime }">
      {{ time }}
    </section>
    <section class="actions">
      <a v-if="started" v-on:click.prevent="finish" href="#">Закончить</a>
      <a v-else v-on:click.prevent="start" href="#">Начать</a>
    </section>
    <section class="today">
      Сегодня {{ today_time }}
    </section>
    <p class="profile-info">Профиль: {{ profileId }}</p>
  </div>
</template>

<script>
import h from './helpers';
export default {
  data() {
    return {
      profileId: null,
      started: false,
      status: '',
      hours: 0,
      minutes: 0,
      today: null,
    };
  },
  created() {
    this.profileId = h.extract_profile_id();
    this.get_status();
    setInterval(() => this.get_status(), 60 * 1000);
  },
  computed: {
    time() {
      const sign = this.isOvertime ? '+' : '';
      return sign + this.hours + ':' + String(this.minutes).padStart(2, '0');
    },
    isOvertime() {
      return this.status === 'overtime';
    },
    today_time() {
      const sign = this.today.status === 'overtime' ? '+' : '';
      return sign + this.today.hours + ':' + String(this.today.minutes).padStart(2, '0');      
    }
  },
  methods: {
    get_status() {
      h.get_status(this.profileId).then(data => {
        this.started = data.started;
        this.status = data.total.status;
        this.hours = data.total.hours;
        this.minutes = data.total.minutes;
        this.today = data.today;
      });
    },
    start() {
      h.start(this.profileId).then(() => this.get_status());
    },
    finish() {
      h.finish(this.profileId).then(() => this.get_status());
    },
  },
};
</script>

<style lang="scss">
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  margin-top: 3em;
}

.timer {
  font-size: 600%;
}

.overtime {
  color: green;
}

.actions {
  font-size: 240%;
}

.today {
  margin-top: 1em;
  font-size: 200%;
}

.profile-info {
  margin-top: 2em;
}
</style>
