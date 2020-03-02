import Vue from 'vue';
import VueRouter from 'vue-router';
import App from './App.vue';

import TimerPage from './TimerPage.vue';
import StatisticsPage from './StatisticsPage.vue';

Vue.use(VueRouter);

const routes = [
  { path: '/', name: 'timer', component: TimerPage },
  { path: '/statistics', name: 'statistics', component: StatisticsPage },
];

const router = new VueRouter({
  routes,
});

new Vue({
  el: '#app',
  router,
  // store,
  render: h => h(App),
});
