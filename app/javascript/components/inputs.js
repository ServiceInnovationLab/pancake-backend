import React from "react"
import { Field } from "react-final-form";
import { FieldArray } from 'react-final-form-arrays'
import { map } from "lodash"

export function SingleInput ({ id, label, placeholder, fullWidth, type = "text" }) {
  return (
  <div key={id} className={fullWidth ? 'full-width' : 'flex-item'}>
    <label>{label}</label>
    <Field
      className='rebate-search-input'
      name={`fields.${id}`}
      label= {label}
      placeholder= {placeholder}
      component='input'
      type={type}
    />
    <Error name={`fields.${id}`} />
  </div>
  )
}
export function TableInput ({ id, className = 'flex-item', type = "number" }) {
  return (
  <div key={id} className={className}>
    <Field
      className='rebate-search-input'
      name={`fields.income.${id}`}
      component='input'
      type={type}
    />
    <Error name={`fields.income.${id}`} />
  </div>
)}

export function RadioInput ({ id, label, type }) {
  return (
    <div key={id}  className="flex-item " >
      <label>{label}</label>
      <div className="flex-row rebate-radio-buttons" >
        {map(["yes", "no"], value =>
        <label key={`${id}-${value}`} >
          <Field
            className="one-quarter"
            name={`fields.${id}`}
            component="input"
            type={type}
            value={value}
          />{" "}
          {value}
        </label>
        )}
        <Error name={`fields.${id}`} />
      </div>
    </div>
  )
}

export function FieldArrayInput () {
  return (
    <FieldArray name={`fields.income.other_income`}>
      {({ fields }) => 
        fields.map((name, index) => (
          <div key={name} className="flex-row">
            {ExtraTableInputs({classname: 'flex-item', name: `${name}other-${index}-applicant`})}
            {ExtraTableInputs({classname: 'flex-item', name: `${name}other-${index}-partner`})}
            <span
              onClick={() => fields.remove(index)}
              style={{ cursor: 'pointer' }}
            >
              ❌
            </span>
          </div>
        ))
      }
    </FieldArray>
  )
}

export function ExtraTableInputs ({ name, type = "number" }) {
  return (
  <div key={name} className='flex-item one-third'>
    <Field
      className='rebate-search-input'
      name={name}
      component='input'
      type={type}
    />
    <Error name={name} />
  </div>
)}

const Error = ({ name }) => (
  <Field name={name} subscription={{ error: true, touched: true }}>
    {({ meta: { error, touched } }) =>
      error && touched ? <span>{error}</span> : null
    }
  </Field>
);
