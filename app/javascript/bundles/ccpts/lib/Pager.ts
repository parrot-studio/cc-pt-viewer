import * as _ from "lodash"
import Arcana from "../model/Arcana"

export default class Pager<T extends Arcana> {
  public static create(list: Arcana[], psize = 8): Pager<Arcana> {
    return new Pager(list, psize)
  }

  public all: T[] = []
  public size: number
  public pageSize: number
  public maxPage: number
  public page: number

  constructor(list: T[], psize = 8) {
    this.all = list
    this.size = list.length
    this.pageSize = psize
    this.maxPage = 1
    if (this.size > 0) {
      this.maxPage = Math.ceil(this.size / this.pageSize)
    }
    this.page = 1
  }

  public head(): number {
    return ((this.page - 1) * this.pageSize) + 1
  }

  public tail(): number {
    let t = (this.page * this.pageSize)
    if (t >= this.all.length) {
      t = this.all.length
    }
    return t
  }

  public get(): T[] {
    const h = this.head() - 1
    const t = this.tail()
    return _.slice(this.all, h, t)
  }

  public nextPage(): number {
    this.page = this.page + 1
    if (this.page > this.maxPage) {
      this.page = this.maxPage
    }
    return this.page
  }

  public prevPage(): number {
    this.page = this.page - 1
    if (this.page < 0) {
      this.page = 1
    }
    return this.page
  }

  public hasNextPage(): boolean {
    return (this.page < this.maxPage)
  }

  public hasPrevPage(): boolean {
    return (this.page > 1)
  }

  public jumpPage(p: number | string): number {
    if (typeof p === "number") {
      this.page = p
    } else {
      this.page = parseInt(p, 10)
    }

    if (this.page > this.maxPage) {
      this.page = this.maxPage
    }
    if (this.page < 0) {
      this.page = 1
    }
    return this.page
  }

  public sort(col: string, order = "desc"): T[] {
    this.all.sort((a, b) => {
      if (a.jobCode === b.jobCode) {
        return 0
      }

      const av = a.valueForSort(col)
      const bv = b.valueForSort(col)
      if (_.eq(av, bv)) {
        return 0
      } else if (av < bv) {
        if (order === "desc") {
          return 1
        } else {
          return -1
        }
      } else {
        if (order === "desc") {
          return -1
        } else {
          return 1
        }
      }
    })
    return this.all
  }
}
