
import React, { Fragment } from "react"
import { Form, Field, FormSpy } from "react-final-form";
import { map } from "lodash"
import 'isomorphic-fetch';

import { getCSRF } from '../helpers/getCSRF';

const appUrl = window.location.origin

class CustomerApplications extends React.Component {
  constructor(props) {
    super(props)
    this.state = { rebateForms: null, applicationState: 'not-completed' }
  }

  fetchRebates (completed = false, name = '') {
    fetch(`${appUrl}/admin/rebate_forms?utf8=✓&completed=${completed}&name=${name || ''}`, {
      method: 'GET',
      headers: {
        'X-CSRF-Token': getCSRF(),
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      credentials: 'same-origin'
    })
      .then(response => {
        return response.json()
      })
      .then(data => {
        this.setState({ rebateForms: data.json })
      })
  }

  onChange(value) {
    const signed = value === 'completed' 
    if(signed) {
      this.setState({applicationState: value})
      this.fetchRebates(signed)
    }
    else {
      this.setState({applicationState: value, rebateForms: null})
    }
  }

  onSubmit(values = {}) {
    this.fetchRebates(false, values.name)
  }

  render() {
    return (
      <Fragment>
        <div className='pure-u-1-2 rebate-search-box'>
          <div className={"rebate-radio-wrapper flex-row"}>
            {map([["Not Signed", 'not-completed'], ["Signed", 'completed']], ([key, value]) =>
              <button key={key} onClick={() => this.onChange(value)}>
              {key}
              </button>
            )}
          </div>
          { !(this.state.applicationState === 'completed') && <Form
            onSubmit={this.onSubmit.bind(this)}
            >
            {({ handleSubmit }) => (
              <form className="pure-form" onSubmit={handleSubmit}>
                <hr />
                <Field
                  className='rebate-search-field rebate-search-input'
                  name="name"
                  component="input"
                  placeholder="E.g. John Doe"
                />
                <button className="pure-button pure-button-primary rebate-search-button" type="submit">
                  Search
              </button>
              </form>
            )}
          </Form>
        }
        </div>
        {(this.state.rebateForms && this.state.rebateForms[0]) && <table className="pure-u-1 pure-table pure-table-bordered rebate-results-table">
          <thead>
            <tr>
              <th>Name</th>
              <th>Address</th>
              <th></th>
            </tr>
          </thead>
          <tbody className='rebate-results-table-body'>
            {map(this.state.rebateForms, (rebateForm, key) => {
              const { property, fields } = rebateForm

              return (
                <tr key={`${key}-${fields.full_name}`} className='rebate_form.completed'>
                  <td className='rebate-results-table-cell'>{fields.full_name}</td>
                  {property
                    ? <td className='rebate-results-table-cell'>{property.location} {property.suburb} {property.town_city}</td>
                    : <td className='rebate-results-table-cell' />
                  }
                  <td className='rebate-results-table-cell'>
                    <img src='/assets/blue-right-arrow.svg' />
                  </td>
                </tr>
              )
            })}
          </tbody>
        </table>
      }
      </Fragment>
    )
  }
}

export default CustomerApplications
