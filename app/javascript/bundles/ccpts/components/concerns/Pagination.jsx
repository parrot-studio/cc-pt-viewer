import React from "react"
import { Pagination } from "react-bootstrap"
import {createUltimatePagination, ITEM_TYPES} from "react-ultimate-pagination"

const WrapperComponent = ({children}) => (
  <ul className="pagination">{children}</ul>
)

const Page = ({value, isActive, onClick}) => (
  <Pagination.Item active={isActive} onClick={onClick}>{value}</Pagination.Item>
)

const Ellipsis = ({onClick}) => (
  <Pagination.Ellipsis onClick={onClick} />
)

const FirstPageLink = ({isActive, onClick}) => (
  <Pagination.First disabled={isActive} onClick={onClick} />
)

const PreviousPageLink = ({isActive, onClick}) => (
  <Pagination.Prev disabled={isActive} onClick={onClick} />
)

const NextPageLink = ({isActive, onClick}) => (
  <Pagination.Next disabled={isActive} onClick={onClick} />
)

const LastPageLink = ({isActive, onClick}) => (
  <Pagination.Last disabled={isActive} onClick={onClick} />
)

const itemTypeToComponent = {
  [ITEM_TYPES.PAGE]: Page,
  [ITEM_TYPES.ELLIPSIS]: Ellipsis,
  [ITEM_TYPES.FIRST_PAGE_LINK]: FirstPageLink,
  [ITEM_TYPES.PREVIOUS_PAGE_LINK]: PreviousPageLink,
  [ITEM_TYPES.NEXT_PAGE_LINK]: NextPageLink,
  [ITEM_TYPES.LAST_PAGE_LINK]: LastPageLink
}

const UltimatePagination = createUltimatePagination({itemTypeToComponent, WrapperComponent});

export default UltimatePagination
