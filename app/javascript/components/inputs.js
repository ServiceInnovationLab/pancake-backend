import React from "react"
import { Field } from "react-final-form";
import { map } from "lodash"

export function SingleInput ({ isReadOnly, id, label, placeholder, fullWidth, type = "text" }) {
  
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
      min={type == 'number' ? 0 : null}
      readOnly={isReadOnly}
    />
    <Error name={`fields.${id}`} />
  </div>
  )
}
export function TableInput ({ id, type = "number", isReadOnly }) {
  return (
  <div key={id} className='one-quarter'>
    <Field
      className='rebate-search-input'
      name={`fields.income.${id}`}
      component='input'
      type={type}
      readOnly={isReadOnly}
      min={0}
    />
    <Error name={`fields.income.${id}`} />
  </div>
)}

export function RadioInput ({ id, label, type, isReadOnly }) {
  return (
    <div key={id}  className="flex-item " >
      <label>{label}</label>
      <div className="flex-row rebate-radio-buttons" >
        {map(["yes", "no"], value =>
        <label key={`${id}-${value}`} >
          <Field
            name={`fields.${id}`}
            component="input"
            type={type}
            value={value}
            readOnly={isReadOnly}
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
