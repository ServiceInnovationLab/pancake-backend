import React from "react"
import { Field } from "react-final-form";
import { map } from "lodash"

import { incomeRows } from '../helpers/data'
import { TableInput } from './inputs'

export function IncomeDeclaration ({otherIncomeFields, isReadOnly, includePartnerValues}) {
  return (
    <div>
      <div className="flex-column">
        <h2 className="full-width">Income declaration (before tax)</h2>
        <div className={'flex-row'}>
          <label className='flex-item'>
            <h3>Total combined income: </h3>
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
            {includePartnerValues && <h2 className="one-quarter" >Partner or joint homeowner</h2>}
        </div>
        {map(incomeRows, ([name, label]) => {
          return (
            <div key={name} className="flex-row">
                <label className="flex-item">
                  <h3>{label || name}</h3>
                </label>
                {TableInput({isReadOnly, className: 'one-quarter with-margin', id: `applicant.${name}`})}
                {includePartnerValues && TableInput({isReadOnly, className: 'one-quarter', id: `partner.${name}`})}
            </div>
          )}
        )}
        {map(otherIncomeFields, (name) => {
          return (
            <div key={name} className="flex-row">
                <label className="flex-item">
                  <h3>{name}</h3>
                </label>
                {TableInput({isReadOnly, className: 'one-quarter with-margin', id: `otherIncome.applicant.${name}`})}
                {includePartnerValues && TableInput({isReadOnly, className: 'one-quarter', id: `otherIncome.partner.${name}`})}
            </div>
          )}
        )}
      </div>
    </div>
  )
}
