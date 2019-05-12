[33mcommit ef8f896475137139f0eb7fa1b3e79e711abd661c[m
Author: inoisy <inoisy@bk.ru>
Date:   Mon May 6 12:55:08 2019 +0300

    fix

[1mdiff --git a/layouts/default.vue b/layouts/default.vue[m
[1mindex 5161a17..98e1183 100644[m
[1m--- a/layouts/default.vue[m
[1m+++ b/layouts/default.vue[m
[36m@@ -12,7 +12,7 @@[m
         <template v-for="(item, i) in navigation">[m
           <v-list-group v-if="item.items.length>0" :key="i">[m
             <v-list-tile slot="activator" :to="localePath(item.to)">[m
[31m-              <v-list-tile-content>{{ item.title }}</v-list-tile-content>[m
[32m+[m[32m              <v-list-tile-content>{{ item.title|| item.title_en }}</v-list-tile-content>[m[41m[m
             </v-list-tile>[m
             <v-list-tile[m
               v-for="it in item.items"[m
[36m@@ -20,12 +20,12 @@[m
               nuxt[m
               :to="it.forms && it.forms.length > 0 ? localePath({ name: 'catalog-slug', params: { slug: it.forms[0].slug } }) : localePath({ name: 'about-slug', params: { slug: it.slug } })"[m
             >[m
[31m-              <v-list-tile-content class="ml-4">{{ it.title }}</v-list-tile-content>[m
[32m+[m[32m              <v-list-tile-content class="ml-4">{{ it.title|| it.title_en}}</v-list-tile-content>[m[41m[m
             </v-list-tile>[m
           </v-list-group>[m
           <v-list-tile v-else :to="localePath(item.to)" :key="i" nuxt exact>[m
             <v-list-tile-content>[m
[31m-              <v-list-tile-title v-text="item.title"/>[m
[32m+[m[32m              <v-list-tile-title v-text="item.title || item.title_en"/>[m[41m[m
             </v-list-tile-content>[m
           </v-list-tile>[m
         </template>[m
