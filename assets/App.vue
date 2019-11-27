<template>
  <div id="app">
    <section
      v-if="today_time"
      class="timer"
      v-bind:class="{ overtime: today_time.isOvertime() }"
    >
      {{ today_time.toStr() }}
    </section>
    <section class="actions">
      <a v-if="started" v-on:click.prevent="finish" href="#">Закончить</a>
      <a v-else v-on:click.prevent="start" href="#">Начать</a>
    </section>
    <section v-if="total_time" class="total">
      Всего
      <span v-bind:class="{ overtime: total_time.isOvertime() }">
        {{ total_time.toStr() }}
      </span>
    </section>
    <p class="profile-info">Профиль: {{ profileId }}</p>
  </div>
</template>

<script>
import TimeSpan from './TimeSpan';
import h from './helpers';
export default {
  data() {
    return {
      profileId: null,
      started: false,
      total_time: null,
      today_time: null,
    };
  },
  created() {
    this.profileId = h.extract_profile_id();
    this.get_status();
    setInterval(() => this.get_status(), 60 * 1000);
  },
  methods: {
    get_status() {
      h.get_status(this.profileId).then(data => {
        this.started = data.started;
        this.total_time = TimeSpan.fromObject(data.total.time);
        this.today_time = TimeSpan.fromObject(data.today.time);
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

.total {
  margin-top: 1em;
  font-size: 200%;
}

.profile-info {
  margin-top: 2em;
}
</style>
