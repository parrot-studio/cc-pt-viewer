export default class QueryResult {

  static create(arcanas, detail) {
    return new QueryResult(arcanas, detail)
  }

  constructor(arcanas, detail) {
    this.arcanas = (arcanas || [])
    this.detail = (detail || '')
  }
}
