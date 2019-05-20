
import React, { Fragment } from "react"
import { map, uniq, indexOf } from "lodash"
import { Form, Field } from "react-final-form";
import 'isomorphic-fetch';

import { conditionalsFields, customerDetailFields } from '../helpers/data'
import { getCSRF } from '../helpers/getCSRF';
import { calculator } from '../helpers/calculator_decorator';

import { SingleInput, RadioInput } from './inputs'
import { IncomeDeclaration } from "./IncomeDeclaration";

const appUrl = window.location.origin  

class EditRebateForm extends React.Component {

  constructor(props) {
    super(props);

    const { rebateForm: { fields: {income} } } = this.props

    const otherIncome = income && income.otherIncome

    const applicantKeys = otherIncome && otherIncome.applicant ? Object.keys(otherIncome.applicant) : []
    const partnerKeys = otherIncome && otherIncome.partner ? Object.keys(otherIncome.partner) : []

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
      : fetch(`${appUrl}/admin/rebate_forms/${this.props.rebateForm.id}`, {
        method: 'PATCH',
        headers: {
          'X-CSRF-Token': getCSRF(),
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          rebate_form: {...values},
          location: values.fields.location,
          total_rates: values.fields.total_rates,
          council: this.props.council.name
        }),
        credentials: 'same-origin'
      }).then(res => {
        console.log('res', res)
        if (res.ok) window.location = `${appUrl}/admin/rebate_forms/${this.props.rebateForm.id}` 
        else console.error(res)
      })
  }

  render () {
    const { 
      rebateForm,
      property,
      isReadOnly
    } = this.props
    const { fields } = rebateForm
    fields.location = property.location
    const initialValues = {fields, location: property.location} 
    const { otherIncomeFields } = this.state

    return (
      <Form
        onSubmit={this.onSubmit.bind(this)}
        initialValues={initialValues}
        decorators={[calculator]}
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
              {map(customerDetailFields, (field, index) => {
                if (indexOf([1, 4, 6, 8, 10, 12], index) >= 0) field.withMargin = true
                return field.type == 'radio'
                ? RadioInput({...field, isReadOnly, values})
                : SingleInput({...field, isReadOnly})
              })}
            </div>
            { values.fields.moved_within_rating_year == 'yes' &&
              <div className="flex-row">
                {map(conditionalsFields, (field, index) => {
                if (indexOf([2, 4, 5], index) >= 0) field.withMargin = true
                return field.type == 'radio'
                ? RadioInput({...field, isReadOnly, values})
                : SingleInput({...field, isReadOnly})
                })}
              </div>   
            }
            {IncomeDeclaration({otherIncomeFields, isReadOnly})}
            { !isReadOnly &&
              <Fragment>
                <div className={'flex-row'}>
                  <Field
                    className='rebate-search-input flex-item'
                    name="newIncomeField"
                    component="input"
                    readOnly={isReadOnly}
                  />
                  <button
                    className='one-third rebate-add-income-button'
                    disabled={isReadOnly || !values.newIncomeField}
                    type="button"
                    onClick={() => this.addNewIncomeValue(values)}
                    >
                      Add Income Type
                  </button>

                </div>
                <div className="rebate-submit-button-wrapper">
                  <button className="one-third rebate-add-income-button rebate-search-button" type="submit" >
                    Submit
                  </button>
                </div>
              </Fragment> 
              }
          </form>
        )}}
      </Form>
    );
  }
}

export default EditRebateForm
