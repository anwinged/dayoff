<template>
  <main id="app">
    <nav id="nav">
      <router-link class="nav-link" :to="{ name: 'timer' }">Таймер</router-link>
      <router-link class="nav-link" :to="{ name: 'statistics' }"
        >Статистика</router-link
      >
    </nav>
    <router-view></router-view>
  </main>
</template>

<script></script>

<style lang="scss" scoped>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  max-width: 400px;
  display: block;
  margin: 2em auto;
}

#nav {
  text-align: center;
  margin: 2em auto;
}

.nav-link {
  display: inline-block;
}

.nav-link + .nav-link {
  margin-left: 0.6em;
}
</style>
