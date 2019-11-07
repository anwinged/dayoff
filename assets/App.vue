<template>
  <div id="app">
    <a v-if="started" v-on:click.prevent="finish" href="#">Закончить</a>
    <a v-else v-on:click.prevent="start" href="#">Начать</a>
  </div>
</template>

<script>
import qs from 'qs';
export default {
  data() {
    return {
      started: false,
    };
  },
  created() {
    const haystack = window.location.search || window.location.hash;
    const q = haystack.substring(haystack.indexOf('?') + 1, haystack.length);
    const query = qs.parse(q);
    const profile = query['profile'] || '';
    console.log('PROFILE', query, profile);
    const p = fetch('/api/status?profile_id=' + profile, {
      method: 'GET',
    });
    p.then(response => {
      return response.json();
    }).then(data => {
      this.started = data.started;
      console.log('DATA', data);
    });
  },
  methods: {
    start() {
      console.log('START');
      this.started = true;
    },
    finish() {
      console.log('FINISH');
      this.started = false;
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
  color: #2c3e50;
}

#nav {
  padding: 30px;

  a {
    font-weight: bold;
    color: #2c3e50;

    &.router-link-exact-active {
      color: #42b983;
    }
  }
}
</style>
