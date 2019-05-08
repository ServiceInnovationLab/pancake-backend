import React from "react"
import { Field } from "react-final-form";
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
export function TableInput ({ id, label, placeholder, type = "text" }) {
  return (
  <div key={id} className='flex-item one-third'>
    <Field
      className='rebate-search-input'
      name={`fields.income.${id}`}
      label= {label}
      placeholder= {placeholder}
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
      <div className="flex-row" >
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

const Error = ({ name }) => (
  <Field name={name} subscription={{ error: true, touched: true }}>
    {({ meta: { error, touched } }) =>
      error && touched ? <span>{error}</span> : null
    }
  </Field>
);
