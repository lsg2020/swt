import Vue from 'vue'
import Router from 'vue-router'
import Layout from '@/layout/index.vue'

Vue.use(Router)

/*
  redirect:                      if set to 'noredirect', no redirect action will be trigger when clicking the breadcrumb
  meta: {
    title: 'title'               the name showed in subMenu and breadcrumb (recommend set)
    icon: 'svg-name'             the icon showed in the sidebar
    breadcrumb: false            if false, the item will be hidden in breadcrumb (default is true)
    hidden: true                 if true, this route will not show in the sidebar (default is false)
  }
*/

export default new Router({
  // mode: 'history',  // Enable this if you need.
  scrollBehavior: (to, from, savedPosition) => {
    if (savedPosition) {
      return savedPosition
    } else {
      return { x: 0, y: 0 }
    }
  },
  base: process.env.BASE_URL,
  routes: [
    {
      path: '/login',
      component: () => import(/* webpackChunkName: "login" */ '@/views/login/index.vue'),
      meta: { hidden: true }
    },
    {
      path: '/404',
      component: () => import(/* webpackChunkName: "404" */ '@/views/404.vue'),
      meta: { hidden: true }
    },
    {
      path: '/',
      component: Layout,
      redirect: '/dashboard',
      children: [
        {
          path: 'dashboard',
          component: () => import(/* webpackChunkName: "dashboard" */ '@/views/dashboard/index.vue'),
          meta: {
            title: 'dashboard',
            icon: 'dashboard'
          }
        }
      ]
    },
    {
      path: '/',
      component: Layout,
      redirect: '/debug',
      children: [
        {
          path: 'debug',
          component: () => import(/* webpackChunkName: "Debug" */ '@/views/debug/index.vue'),
          meta: {
            title: 'Debug',
            icon: 'example'
          }
        }
      ]
    },
    {
      path: '/',
      component: Layout,
      redirect: '/profiler',
      children: [
        {
          path: 'profiler',
          component: () => import(/* webpackChunkName: "Profiler" */ '@/views/profiler/index.vue'),
          meta: {
            title: 'Profiler',
            icon: 'example'
          }
        }
      ]
    },
    {
      path: '*',
      redirect: '/404',
      meta: { hidden: true }
    }
  ]
})
