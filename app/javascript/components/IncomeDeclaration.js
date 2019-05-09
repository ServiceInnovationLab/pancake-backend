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
          <label className='one-third'>
            <h3>Total Combined Income: </h3>
          </label>
          <Field
            className='rebate-search-input one-third'
            name="fields.income.total_income"
            component="input"
            readOnly
          />
        </div>
        <div className="flex-row">
          {map(['Income Type', 'Applicant', 'Partner'], title => (
            <h2 key={title} className="flex-item one-third" >{title}</h2>
          ))}
        </div>
        {map(incomeRows, (field) => {
        return (
          <div key={field.id} className="flex-row">
              <label className="flex-item one-third">
                <h3>{field.label}</h3>
              </label>
              {TableInput({...field, id: `applicant.${field.id}`})}
              {TableInput({...field, id: `partner.${field.id}`})}
          </div>
        )
        })}
        <div>
        {FieldArrayInput({name: 'other_income'})}
        </div>
      </div>
    </div>
  )
}