import _ from "lodash"

export default class Pager {

  static create(list = [], psize = 8) {
    return new Pager(list, psize)
  }

  constructor(list = [], psize = 8) {
    this.all = list
    this.size = list.length
    this.pageSize = psize
    this.maxPage = 1
    if (this.size > 0) {
      this.maxPage = Math.ceil(this.size / this.pageSize)
    }
    this.page = 1
  }

  head() {
    return ((this.page - 1) * this.pageSize) + 1
  }

  tail() {
    let t = (this.page * this.pageSize)
    if (t >= this.all.length) {
      t = this.all.length
    }
    return t
  }

  get() {
    const h = this.head() - 1
    const t = this.tail()
    return _.slice(this.all, h, t)
  }

  nextPage() {
    this.page = this.page + 1
    if (this.page > this.maxPage){
      this.page = this.maxPage
    }
    return this.page
  }

  prevPage() {
    this.page = this.page - 1
    if (this.page < 0){
      this.page = 1
    }
    return this.page
  }

  hasNextPage() {
    return (this.page < this.maxPage)
  }

  hasPrevPage() {
    return (this.page > 1)
  }

  jumpPage(p) {
    this.page = parseInt(p)
    if (this.page > this.maxPage) {
      this.page = this.maxPage
    }
    if (this.page < 0) {
      this.page = 1
    }
    return this.page
  }

  sort(col, order = "desc") {
    this.all.sort((a, b) => {
      if (_.eq(a.jobCode, b.jobCode)) {
        return 0
      }

      let av = a[col]
      if (_.eq(av, "-")) {
        av = 0
      }
      let bv = b[col]
      if (_.eq(bv, "-")) {
        bv = 0
      }

      if (_.eq(av, bv)) {
        return 0
      } else if (av < bv) {
        if (_.eq(order, "desc")) {
          return 1
        } else {
          return -1
        }
      } else {
        if (_.eq(order, "desc")) {
          return -1
        } else {
          return 1
        }
      }
    })
    return this.all
  }
}
