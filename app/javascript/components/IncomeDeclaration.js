import React from "react"
import { Field } from "react-final-form";
import { map } from "lodash"

import { incomeRows } from '../helpers/data'
import { TableInput } from './inputs'

export function IncomeDeclaration ({otherIncomeFields, isReadOnly}) {
  return (
    <div>
      <div className="flex-column">
        <h2 className="full-width">Income declaration (before tax)</h2>
        <div className={'flex-row'}>
          <label className='flex-item'>
            <h3>Total Combined Income: </h3>
          </label>
          <Field
            className='rebate-search-input flex-item'
            name="fields.income.total_income"
            component="input"
            readOnly
          />
        </div>
        <div className="flex-row">
            <h2 className="flex-item" >Income Type</h2>
            <h2 className="one-quarter" >Applicant</h2>
            <h2 className="one-quarter" >Partner</h2>
        </div>
        {map([...incomeRows, ...otherIncomeFields], field => {
          const isArray = typeof field == 'object'
          const name = isArray ? field[0] : field
          const label = isArray ? field[1] : field
          
          return (
            <div key={name} className="flex-row">
                <label className="flex-item">
                  <h3>{label || name}</h3>
                </label>
                {TableInput({isReadOnly, className: 'one-quarter with-margin', id: `otherIncome.applicant.${name}`})}
                {TableInput({isReadOnly, className: 'one-quarter', id: `otherIncome.partner.${name}`})}
            </div>
          )}
        )}
      </div>
    </div>
  )
}