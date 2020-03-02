<template>
  <table class="stat-table">
    <tr>
      <th>Дата</th>
      <th>План</th>
      <th>Работа</th>
      <th></th>
    </tr>
    <tr v-for="item in statistics">
      <td class="date">{{ item.date }}</td>
      <td class="planned">{{ item.planned.total_minutes | tt }}</td>
      <td class="worked">{{ item.worked.total_minutes | tt }}</td>
      <td class="worked">
        {{ (item.worked.total_minutes - item.planned.total_minutes) | td }}
      </td>
    </tr>
  </table>
</template>

<script>
import h from './helpers';
export default {
  data() {
    return {
      statistics: [],
    };
  },
  created() {
    this.profileId = h.extract_profile_id();
    this.get_statistics();
  },
  methods: {
    get_statistics() {
      h.get_statistics(this.profileId).then(data => {
        this.statistics = data;
      });
    },
  },
  filters: {
    tt(v) {
      const h = Math.round(v / 60);
      const m = v % 60;
      return (h ? h : '00') + ':' + String(m).padStart(2, '0');
    },
    td(v) {
      const o = v > 0;
      const a = Math.abs(v);
      const h = Math.round(a / 60);
      const m = a % 60;
      const t = (h ? h : '00') + ':' + String(m).padStart(2, '0');
      return (o ? '+' : '-') + t;
    },
  },
};
</script>

<style lang="scss" scoped>
.stat-table {
  margin: 1em auto;
  border-collapse: collapse;
  width: 100%;

  th,
  td {
    border: 1px solid #ddd;
    padding: 10px 6px;
  }

  .date,
  .planned,
  .worked {
    text-align: center;
  }
}
</style>
