import React from "react"
import { Field } from "react-final-form";
import { map } from "lodash"

import { incomeRows } from '../helpers/data'
import { TableInput, FieldArrayInput } from './inputs'

export function IncomeDeclaration () {
  return (
    <div>
      <div className="flex-column">
        <h2 className="flex-item">Income declaration (before tax)</h2>
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
        {map(incomeRows, (field) => {
        return (
          <div key={field.id} className="flex-row">
              <label className="flex-item">
                <h3>{field.label}</h3>
              </label>
              {TableInput({...field, className: 'one-quarter', id: `applicant.${field.id}`})}
              {TableInput({...field, className: 'one-quarter', id: `partner.${field.id}`})}
          </div>
        )
        })}
        <div>
        {FieldArrayInput()}
        </div>
      </div>
    </div>
  )
}