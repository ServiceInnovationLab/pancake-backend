import React from "react"
import { Field } from "react-final-form";
import { map } from "lodash"

import { incomeRows } from '../helpers/data'
import { TableInput, ExtraTableInputs } from './inputs'

export function IncomeDeclaration ({otherIncomeFields}) {
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
         {map(otherIncomeFields, (value, key) => {
          return (
            <div key={key} className="flex-row">
                <label className="flex-item">
                  <h3>{key}</h3>
                </label>
                {ExtraTableInputs({id: `applicant.${key}`})}
                {ExtraTableInputs({id: `partner.${key}`})}
            </div>
          )
          })}
        </div>
    </div>
  )
}