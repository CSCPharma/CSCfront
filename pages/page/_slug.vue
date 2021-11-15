<template>
  <div>
    <div class="main-bg">
      <div class="main-bg-image" :style="page.img ? `background-image: url(${imageBaseUrl+page.img.url});` : ''"></div>
      <v-container class="position-relative fill-height ma-auto py-5">
        <v-layout>
          <v-flex class="xs12 text-xs-center">
            <h1 class="main-header mb-4" v-text="page.title"/>
            <breadcrumbs :items="breadcrumbsItems"/>
          </v-flex>
        </v-layout>
      </v-container>
    </div>

    <div class="pt-5 container" v-html="page.content"></div>
    <v-container class="py-5" grid-list-xl v-if="page.gallery && page.gallery.length > 0">
      <v-layout wrap>
        <h2 class="flex xs12 mb-4">{{locale.gallery}}</h2>
        <v-flex xs12>
          <v-carousel height="auto">
            <v-carousel-item v-for="(item,i) in page.gallery" :key="i">
              <v-img :src="imageBaseUrl+item.url" :aspect-ratio="14/9"></v-img>
            </v-carousel-item>
          </v-carousel>
        </v-flex>
      </v-layout>
    </v-container>
  </div>
</template>
<style lang="scss" scoped>
// .main-bg {
//   min-height: 40vh;
// }
</style>
<script>
import Breadcrumbs from "~/components/Breadcrumbs";
import gql from "graphql-tag";

export default {
  data() {
    return {
      imageBaseUrl: process.env.imageBaseUrl
    };
  },
  head() {
    return {
      title: this.page.title,
      meta: [
        // hid is used as unique identifier. Do not use `vmid` for it as it will not work
        {
          hid: "description",
          name: "description",
          content: this.page.description
        }
      ]
    };
  },
  components: { Breadcrumbs },
  async asyncData(ctx) {
    const locale = ctx.app.i18n.locale;
    let client = ctx.app.apolloProvider.defaultClient;
    let query;
    if (locale === "ru") {
      query = gql`
        query pagesQuery($slug: String!) {
          locales(where: { name: "ru" }) {
            vacancies
            catalog
            aboutUs
            mainPage
            contacts
            copyright
            name
            readAlso
            gallery
          }
          pages(where: { slug: $slug }) {
            title
            description
            slug
            content
            gallery {
              url
            }
            icon {
              url
            }
            img {
              url
            }
          }

          aboutPages: pages(
            sort: "itemsOrder:ask"
            where: { slug: ["story", "charity", "mission", "team"] }
          ) {
            title
            slug
            icon {
              url
            }
          }
          pills(sort: "title:ask") {
            title
            forms {
              title
              slug
            }
          }
        }
      `;
    } else if (locale === "en") {
      query = gql`
        query pagesQuery($slug: String!) {
          locales(where: { name: "en" }) {
            vacancies
            catalog
            aboutUs
            mainPage
            contacts
            copyright
            name
            readAlso
            gallery
          }
          pages(where: { slug: $slug }) {
            title_en
            description_en
            slug
            content_en
            gallery {
              url
            }
            icon {
              url
            }
            img {
              url
            }
          }

          aboutPages: pages(
            sort: "itemsOrder:ask"
            where: { slug: ["story", "charity", "mission", "team"] }
          ) {
            title_en
            slug
            itemsOrder
            icon {
              url
            }
          }
          pills(sort: "title:ask", where: { title_ne: "Диалрапид" }) {
            title_en
            forms {
              title_en
              slug
            }
          }
        }
      `;
    }
    let { data } = await client.query({
      variables: {
        slug: ctx.route.params.slug
      },
      query: query
    });
    // console.log(enData);
    if (locale === "en") {
      for (let dataItem of Object.keys(data)) {
        data[dataItem] = data[dataItem].map(item => {
          let newObj = {};
          for (let i of Object.keys(item)) {
            if (i.includes("_en")) {
              newObj[i.replace("_en", "")] = item[i];
            } else {
              newObj[i] = item[i];
            }
          }
          return newObj;
        });
      }
    }
    ctx.store.commit("pills", data.pills);
    ctx.store.commit("aboutPages", data.aboutPages);
    ctx.store.commit("locale", data.locales[0]);
    return {
      page: data.pages[0]
    };
  },
  computed: {
    locale() {
      return this.$store.state.locale;
    },
    aboutPages() {
      return this.$store.state.aboutPages.filter(
        item => !(item.slug === this.$route.params.slug)
      );
    },
    breadcrumbsItems() {
      return [
        {
          text: this.$store.state.locale.mainPage,
          to: this.localePath("index")
        },
        {
          text: this.page.title,
          to: this.$route.path
        }
      ];
    }
  }
};
</script>


