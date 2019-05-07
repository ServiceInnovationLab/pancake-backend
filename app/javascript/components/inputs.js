import React from "react"
import { Form, Field } from "react-final-form";
import { map } from "lodash"

export function SingleInput ({ id, label, placeholder, fullWidth, type = "text" }) {
  return (
  <div key={id} className={fullWidth ? 'full-width' : 'flex-item'}>
    <label>{label}</label>
    <Field
      className='rebate-search-input'
      name={id}
      label= {label}
      placeholder= {placeholder}
      component='input'
      type={type}
    />
    <Error name={id} />
  </div>
  )
}
export function TableInput ({ id, label, placeholder, type = "text" }) {
  return (
  <div key={id} className='rebate-search-input'>
    <Field
      name={id}
      label= {label}
      placeholder= {placeholder}
      component='input'
      type={type}
    />
    <Error name={id} />
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
            name={id}
            component="input"
            type={type}
            value={value}
          />{" "}
          {value}
        </label>
        )}
        <Error name={id} />
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
