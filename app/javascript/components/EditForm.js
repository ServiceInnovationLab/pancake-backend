
import React from "react"
import { map, uniq } from "lodash"
import { Form, Field } from "react-final-form";
import 'isomorphic-fetch';

import { conditionalsFields, customerDetailFields } from '../helpers/data'
import { getCSRF } from '../helpers/getCSRF';
import { calculator } from '../helpers/calculator_decorator';

import { SingleInput, RadioInput } from './inputs'
import { IncomeDeclaration } from "./IncomeDeclaration";

const databaseURL = process.env.APP_URL  

class EditRebateForm extends React.Component {

  constructor(props) {
    super(props);

    const { rebateForm: { fields: {income} } } = this.props

    const applicantKeys = income && income.otherIncome ? Object.keys(income.other_income.applicant) : []
    const partnerKeys = income && income.otherIncome ? Object.keys(income.other_income.partner) : []
    const uniqKeys = uniq(applicantKeys.concat(partnerKeys))

    this.state = { otherIncomeFields: uniqKeys }
  }
  addNewIncomeValue (values) {
    this.setState({otherIncomeFields: this.state.otherIncomeFields.concat(values.newIncomeField)})
    values.newIncomeField = null
  }

  onSubmit (values) {
    return values.newIncomeField
      ? this.addNewIncomeValue(values)
      : fetch(`${databaseURL}admin/rebate_forms/${this.props.rebateForm.id}`, {
        method: 'PATCH',
        headers: {
          'X-CSRF-Token': getCSRF(),
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          rebate_form: {...values}
        }),
        credentials: 'same-origin'
      }).then(res => {
        if (res.ok) window.location = `${databaseURL}admin/rebate_forms/${this.props.rebateForm.id}` 
        else console.error(res)
      })
  }

  render () {
    const { 
      rebateForm,
      property,
      ratesBills,
      isEditable
    } = this.props
    const { fields } = rebateForm
    const initialValues = {fields, ratesBills: ratesBills[0], property} 
    const { otherIncomeFields } = this.state

    return (
      <Form
        onSubmit={this.onSubmit.bind(this)}
        initialValues={initialValues}
        decorators={[calculator]}
        validate={values => {
          const errors = {};
          {map(initialValues, (value, key) => {
            if (!values[key]) {
              errors[key] = "Required";
            } 
          })}
          return errors;
        }}
      >
        {({
          handleSubmit,
          submitting,
          values,
        }) => {
          return (
          <form
            className="rebate-edit-form"
            onSubmit={handleSubmit}
           >
            <div className="flex-row">
              {map(customerDetailFields, (field) => {
                return field.type == 'radio'
                ? RadioInput({...field, isEditable})
                : SingleInput({...field, isEditable})
              })}
            </div>
            { values.fields.moved_within_rating_year == 'yes'
            ? <div className="flex-row">
                {map(conditionalsFields, (field) => {
                return field.type == 'radio'
                ? RadioInput({...field, isEditable})
                : SingleInput({...field, isEditable})
                })}
              </div>
              : null
            }
            {IncomeDeclaration({otherIncomeFields, isEditable})}
            <div className={'flex-row'}>
              <label className='flex-item'>
                <h3>Additional Income Type: </h3>
              </label>
              <Field
                className='rebate-search-input flex-item'
                name="newIncomeField"
                component="input"
                readOnly={!isEditable}
              />
            </div>
            <div className="buttons">
              <button
                disabled={!isEditable || !(values.newIncomeField)}
                type="button"
                onClick={() => this.addNewIncomeValue(values)}
                >
                  Add Income Type
              </button>
              <button type="submit" disabled={submitting}>
                Submit
              </button>
            </div>
            <pre>{JSON.stringify(values, 0, 2)}</pre>
          </form>
        )}}
      </Form>
    );
  }
}

export default EditRebateForm
